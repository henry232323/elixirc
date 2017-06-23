defmodule Elixirc.EventManager do
  use GenStage
  require Logger

  def start_link(socket) do
    Task.start(fn -> Elixirc.Connection.sock_read(socket, "") end)
    GenStage.start_link(__MODULE__, socket, name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_cast({:command, {command, args}}, state) do
    {:noreply, [{:command, {command, args, state}}], state}
  end

  def handle_cast({:send, args}, state) do
    request = Enum.join(args, " ") <> "\r\n"
    Elixirc.Connection.Connector.send(state, request)
    Logger.info("Sent message: #{request}")
    {:noreply, [{:send, {request}}], state}
  end

  def handle_cast(:close, state) do
    Elixirc.Connection.Connector.close(state)
    Logger.info("Closed socket.")
    {:noreply, [{:close, {}}], state}
  end

  def handle_cast({:socket_closed, reason}, state) do
    state = if state["reconnect"] do
      {:ok, socket} = Elixirc.Connection.Connector.connect(%{ssl?: state.ssl}, state.address, state.port)
      ts = %{state | socket: %{ssl?: state.ssl, socket: socket}}
      Task.start(fn -> Elixirc.Connection.sock_read(ts, "") end)
      ts
    else
      state
    end
    {:noreply, [{:socket_closed, {reason}}], state}
  end

  def handle_cast({cast, args}, state) do
    {:noreply, [{cast, args}], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  def start(_type, [socket]) do
    start_link(socket)
  end
end

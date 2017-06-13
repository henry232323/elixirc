defmodule Elixirc.EventManager do
  use GenStage

  defmodule State do
    defstruct address: "",
              port: "",
              ssl: false,
              nick: "",
              name: "",
              user: "",
              pass: "",
              pinging: false,
              channels: [],
              users: [],
              socket: nil
  end

  def start_link(state) do
    Task.start(fn -> Elixirc.Connection.sock_read(state.socket, "") end)
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_cast({:command, {command, args}}, state) do
    {:noreply, [{command, args, state}], state}
  end

  def handle_cast({:send, args}, state) do
    request = Enum.join(args, " ") <> "\r\n"
    Elixirc.Connection.Connector.send(state.socket, request)
    IO.inspect(request)
    {:noreply, [:send], state}
  end

  def handle_cast({cast, args}, state) do
    {:noreply, [cast], state}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def start(_type, [socket]) do
    start_link(socket)
  end
end

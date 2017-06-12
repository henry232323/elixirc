defmodule Elixirc.EventManager do
  use GenStage

  defmodule State do
    defstruct address: "",
              port: "",
              nick: "",
              name: "",
              user: "",
              pass: "",
              pinging: "",
              channels: [],
              users: [],
              socket: nil
  end

  def start_link(socket) do
    Task.async(fn -> Elixirc.Connection.sock_read(socket, "") end)
    GenStage.start_link(__MODULE__, %State{socket: socket}, name: EventManager)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_cast({:parse, message}, state) do
    message = String.strip(message)
    parts = String.split(message)
    if String.starts_with?(parts[0], ":") do
      [prefix|rest] = parts[0]
      [command | args] = rest
    else
      prefix = nil
      [command | args] = parts
    end

    command = String.downcase(command)
    args = Elixirc.Events.check_args(args)

    if Map.has_key?(Elixirc.Events.events, command) do
      {:noreply, [Elixirc.Events.events[command], args], state}
    else
      {:noreply, [command, args], state}
    end
  end

  def handle_cast({:send, args}, state) do
    request = Enum.join(args, " ") ++ "\r\n"
    Elixirc.Connection.Connector.send(state.socket, request)
    {:noreply, [:send, args], state}
  end

  def start(_type, [socket]) do
    start_link(socket)
  end
end

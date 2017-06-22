defmodule Elixirc do
  use Supervisor
  import Supervisor.Spec

  defmodule State do
    defstruct address: "",
              port: "",
              ssl: false,
              nick: "",
              name: "",
              user: "",
              pass: "",
              pinging: false,
              reconnect: false,
              channels: {},
              users: %{},
              socket: nil,
              state: %{} # sub state
  end

  def start!(state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, socket} = Elixirc.Connection.Connector.connect(%{ssl?: state.ssl}, state.address, state.port)
    children = [
      worker(Elixirc.EventManager, [%{state | socket: %{ssl?: state.ssl, socket: socket}}], restart: :temporary),
    ]
    supervise(children, strategy: :one_for_one)
  end
end

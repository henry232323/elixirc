defmodule Elixirc do
  use Supervisor
  import Supervisor.Spec

  def start!(state) do
    Supervisor.start_link(__MODULE__, [state], name: __MODULE__)
  end

  def init([state]) do
    {:ok, socket} = Elixirc.Connection.Connector.connect(%{ssl?: state.ssl}, state.address, state.port)
    children = [
      worker(Elixirc.EventManager, [%Elixirc.EventManager.State{state | socket: %{ssl?: state.ssl, socket: socket}}], restart: :temporary),
      worker(Elixirc.Consumer, [], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end

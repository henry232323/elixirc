defmodule Elixirc do
  use Supervisor
  import Supervisor.Spec

  def start!(%{ssl?: ssl?}, host, port) do
    Supervisor.start_link(__MODULE__, [%{ssl?: ssl?}, host, port], name: :elixirc)
  end

  def init([%{ssl?: ssl?}, host, port]) do
    {:ok, socket} = Elixirc.Connection.Connector.connect(%{ssl?: ssl?}, host, port)
    children = [
      worker(Elixirc.EventManager, [socket], restart: :temporary),
      worker(ExampleConsumer, [], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end

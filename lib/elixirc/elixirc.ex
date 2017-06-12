defmodule Elixirc do
  use Supervisor
  import Supervisor.Spec

  def start!(%{ssl?: ssl?}, host, port, options) do
    Supervisor.start_link(__MODULE__, [%{ssl?: ssl?}, host, port, options], name: :elixirc)
  end

  def init([%{ssl?: ssl?}, host, port, options]) do
    {:ok, socket} = Elixirc.Connection.Connector.connect(%{ssl?: ssl?}, host, port, options)
    children = [
      worker(Elixirc.EventManager, [socket], restart: :transient),
      worker(Elixirc.ExampleConsumer, [], restart: :transient)
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Elixirc do
  use Supervisor
  import Supervisor.Spec

  def start! do
    Supervisor.start_link(__MODULE__, [], name: :elixirc)
  end

  def start_client! do
    Supervisor.start_child(:elixirc, [[owner: self()]])
  end

  def start_link! do
    Elixirc.EventManager.start!([owner: self()])
  end

  def init(_) do
    children = [
      worker(Elixirc.EventManager, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end

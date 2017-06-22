defmodule TestSupervisor do
  use Supervisor
  import Supervisor.Spec

  def start(pid) do
    chars = "abcdefghijklmnopqrstuvwxyz"
            |> String.split("")

    name = Enum.reduce((1..10), [], fn (_i, acc) ->
           [Enum.random(chars) | acc]
           end) |> Enum.join("")

    state = %Elixirc.State{address: 'irc.mindfang.org',
                           port: 6667,
                           ssl: false,
                           nick: name,
                           name: "pcc31",
                           pinging: true,
                           state: pid}
    Elixirc.start!(state)
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(TestConsumer, [:ok], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule TestConsumer do
  use Elixirc.Consumer
  alias Elixirc.Client

  def start_link(:ok) do
    Elixirc.Consumer.start_link(__MODULE__, :ok)
  end

  def handle_command(:welcome, _args, state) do
    send(state.state, :welcome)
    Client.send(["JOIN", "#elixir-lang"])
    {:ok, state}
  end

  def handle_command(:notice, _args, state) do
    send(state.state, :notice)
    Client.send(["NICK", state.nick])
    Client.send(["USER", state.name, state.address, state.address, state.name])
    {:ok, state}
  end

  def handle_command(_command, _args, state) do
    {:ok, state}
  end
end


defmodule ElixircTest do
  use ExUnit.Case
  doctest Elixirc

  test "commands and connection" do
      TestSupervisor.start(self())
      assert_receive :notice, 30000
      assert_receive :welcome, 30000
      Elixirc.Client.close()
  end
end

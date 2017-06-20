defmodule TestConsumer do
  use Supervisor
  import Supervisor.Spec

  def start(_type, _args) do
    state = %Elixirc.State{address: 'irc.mindfang.org',
                                                    port: 1413,
                                                    ssl: false,
                                                    nick: "Henry",
                                                    name: "pcc31",
                                                    pinging: true}
    Elixirc.start!(state)
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(TC, [:ok], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule TC do
  use Elixirc.Consumer
  alias Elixirc.Client

  def start_link(:ok) do
    Elixirc.Consumer.start_link(__MODULE__, :ok)
  end

  def handle_event(:mode, _args, state) do
    Client.send(["JOIN", "#pesterchum"])
    {:ok, state}
  end

  def handle_event(:notice, _args, state) do
    IO.puts("Connected!")
    Client.send(["NICK", state.nick])
    Client.send(["USER", state.name, state.address, state.address, state.name])
    {:ok, state}
  end

  def handle_event(:ping, [msg | msg], state) do
    if state.pinging do
      Client.send(["PONG", msg])
    end
    {:ok, state}
  end

  def handle_event(:namreply, [_user, "=", _channame, _name | names], state) do
    users = names
            |> String.replace_prefix(":", "")
            |> String.split(" ")
    {:ok, %{state | users: users}}
  end

  def handle_event(:join, [user, _channel], state) do
    {:ok, %{state | users: List.insert_at(state.users, -1, user)}}
  end

  def handle_event(:part, [user, _channel], state) do
    {:ok, %{state | users: List.delete(state.users, user)}}
  end

  def handle_event(_command, _args, state) do
    {:ok, state}
  end
end

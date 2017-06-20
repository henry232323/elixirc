# elixirc
A small lightweight Elixir IRC library based off the Python IRC library [aioyoyo](https://github.com/henry232323/aioyoyo)/oyoyo

# Example usage
```elixir
defmodule ElixircTest do
  use Supervisor
  import Supervisor.Spec

  def start(_type, _args) do
    state = %Elixirc.State{address: 'chat.freenode.net',
                           port: 6667,
                           ssl: false,
                           nick: "henry232323",
                           name: "henry232323",
                           pinging: true}
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

  def handle_command(:mode, _args, state) do
    Client.send(["JOIN", "#pesterchum"])
    {:ok, state}
  end

  def handle_command(:notice, _args, state) do
    IO.puts("Connected!")
    Client.send(["NICK", state.nick])
    Client.send(["USER", state.name, state.address, state.address, state.name])
    {:ok, state}
  end

  def handle_command(:namreply, [_user, "=", _channame, _name | names], state) do
    users = names
            |> String.replace_prefix(":", "")
            |> String.split(" ")
    {:ok, %{state | users: users}}
  end

  def handle_command(:join, [user, _channel], state) do
    {:ok, %{state | users: List.insert_at(state.users, -1, user)}}
  end

  def handle_command(:part, [user, _channel], state) do
    {:ok, %{state | users: List.delete(state.users, user)}}
  end

  def handle_command(_command, _args, state) do
    {:ok, state}
  end
end
```

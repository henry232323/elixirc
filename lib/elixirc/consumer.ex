defmodule Elixirc.Consumer do
    use GenStage
    alias Elixirc.Client
    require Logger

    def start_link(module, :ok) do
      GenStage.start_link(__MODULE__, module, name: __MODULE__)
    end

    def init(state) do
      {:consumer, state, subscribe_to: [Elixirc.EventManager]}
    end

    defmacro __using__(_) do
      quote location: :keep do
        def handle_command(_command, _args, state) do
          {:ok, state}
        end

        defoverridable [handle_command: 3]
      end
    end

    def handle_command(:ping, [msg | msg], state) do
      if state.pinging do
        Client.send(["PONG", msg])
      end
      {:ok, state}
    end

    def handle_command(:namreply, [_user, "=", channel, _name | names], state) do
      users = names
              |> String.replace_prefix(":", "")
              |> String.split(" ")
      {:ok, %{state | users: Map.put(state.users, channel, users)}}
    end

    def handle_command(:join, [user, channel], state) do
      {:ok, %{state | users: Map.put(state.users, channel, List.insert_at(state.users[channel], -1, user))}}
    end

    def handle_command(:part, [user, channel], state) do
      {:ok, %{state | users: Map.put(state.users, channel, List.delete(state.users[channel], user))}}
    end

    def handle_command(:notice, _args, state) do
      Logger.info("Received :notice, sending login #{state.nick}, #{state.user}")
      Client.send(["NICK", state.nick])
      Client.send(["USER", state.name, state.address, state.address, state.name])
      {:ok, state}
    end

    def handle_events([{command, args, clientstate}], _from, module) do
      overrides = [:part, :join, :namreply, :ping, :notice]
      if command in overrides do
        {:ok, clientstate} = handle_command(command, args, clientstate)
      end
      {:ok, newclientstate} = module.handle_command(command, args, clientstate)
      GenStage.cast(Elixirc.EventManager, {:update_state, newclientstate})
      {:noreply, [], module}
    end

    def handle_events(_events, _from, module) do
      {:noreply, [], module}
    end
end

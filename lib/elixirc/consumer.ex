defmodule Elixirc.Consumer do
    use GenStage
    alias Elixirc.Client
    require Logger

    def start_link(module, state) do
      GenStage.start_link(__MODULE__, %{state: state, module: module}, name: __MODULE__)
    end

    def init(state) do
      {:consumer, state, subscribe_to: [Elixirc.EventManager]}
    end

    defmacro __using__(_) do
      quote location: :keep do
        def handle_command(_command, _args, state) do
          {:ok, state}
        end

        def handle_event(_command, _args, state) do
          {:ok, state}
        end

        defoverridable [handle_command: 3, handle_event: 3]
      end
    end

    defp handle_command_internal(:ping, [msg | msg], state) do
      if state.pinging do
        Client.send(["PONG", msg])
      end
      {:ok, state}
    end

    defp handle_command_internal(:namreply, [_user, "=", channel, _name | names], state) do
      users = names
              |> String.replace_prefix(":", "")
              |> String.split(" ")
      {:ok, %{state | users: Map.put(state.users, channel, users)}}
    end

    defp handle_command_internal(:join, [user, channel], state) do
      {:ok, %{state | users: Map.put(state.users, channel, List.insert_at(state.users[channel], -1, user))}}
    end

    defp handle_command_internal(:part, [user, channel], state) do
      {:ok, %{state | users: Map.put(state.users, channel, List.delete(state.users[channel], user))}}
    end

    defp handle_command_internal(:notice, _args, state) do
      Logger.info("Received :notice, sending login #{state.nick}, #{state.name}")
      Client.send(["NICK", state.nick])
      Client.send(["USER", state.name, state.address, state.address, state.name])
      if state.pass != "" do
        Client.send_nickserv("IDENTIFY", state.pass)
      end
      {:ok, state}
    end

    def handle_events(events, _from, %{module: module, state: state}) do
      overrides = [:notice, :part, :join, :namreply, :ping]
      new_state = Enum.reduce(events, state, fn
        {:command, {command, args, _socket}}, newstate ->
          {:ok, newstate} = if command in overrides do
                  handle_command_internal(command, args, newstate)
                else
                  {:ok, state}
                end
          {:ok, newstate} = module.handle_command(command, args, newstate)
          newstate
        {event, args}, newstate ->
          {:ok, newstate} = module.handle_event(event, args, newstate)
          newstate
      end)

      {:noreply, [], %{module: module, state: new_state}}
    end

    def handle_events(_events, _from, module) do
      {:noreply, [], module}
    end
end

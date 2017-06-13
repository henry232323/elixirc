defmodule Elixirc.Consumer do
    use GenStage
    alias Elixirc.Client

    def start_link do
      GenStage.start_link(__MODULE__, :ok)
    end

    def init(:ok) do
      {:consumer, :ok, subscribe_to: [Elixirc.EventManager]}
    end

    def handle_events([{:mode, _args, _clientstate}], _from, state) do
      Client.send(["JOIN", "#pesterchum"])
      {:noreply, [], state}
    end

    def handle_events([{:notice, args, clientstate}], _from, state) do
      IO.inspect("Connected!")
      Client.send(["NICK", clientstate.nick])
      Client.send(["USER", clientstate.name, clientstate.address, clientstate.address, clientstate.name])
      {:noreply, [], state}
    end

    def handle_events([{:ping, [msg | msg], clientstate}], _from, state) do
      if clientstate.pinging do
        Client.send(["PONG", msg])
      end
      {:noreply, [], state}
    end

    #def handle_events([{:namreply, [_user, "=", _channame, _name | names], clientstate}], _from, state) do
    #  users = names
    #          |> String.replace_prefix(":", "")
    #          |> String.split(" ")
    #  {:noreply, [], %Elixirc.EventManager.State{state | users: users}}
    #end
    #
    #def handle_events([{:join, [user, channel], clientstate}], _from, state) do
    #  {:noreply, [], %Elixirc.EventManager.State{state | users: List.insert_at(state.users, -1, user)}}
    #end

    #def handle_events([{:part, [user, channel], clientstate}], _from, state) do
    #  {:noreply, [], %Elixirc.EventManager.State{state | users: List.delete(state.users, user)}}
    #end

    def handle_events(events, _from, state) do
      IO.inspect(events)
      {:noreply, [], state}
    end

    defmacro __using__(_) do
      quote location: :keep do
        @behaviour Elixirc.Consumer
        alias Elixirc.Consumer

        def handle_event(_event, state) do
          {:ok, state}
        end

        defoverridable [handle_event: 2]
      end
    end
end

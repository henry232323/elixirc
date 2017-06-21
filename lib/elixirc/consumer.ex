defmodule Elixirc.Consumer do
    use GenStage
    alias Elixirc.Client

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

    def handle_events([{command, args, clientstate}], _from, module) do
      {:ok, newclientstate} = module.handle_command(command, args, clientstate)
      GenStage.cast(Elixirc.EventManager, {:update_state, newclientstate})
      {:noreply, [], module}
    end

    def handle_events(_events, _from, module) do
      {:noreply, [], module}
    end
end

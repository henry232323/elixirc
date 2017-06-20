defmodule Elixirc.Consumer do
    use GenStage

    def start_link(module, :ok) do
      GenStage.start_link(__MODULE__, module, name: __MODULE__)
    end

    def init(state) do
      {:consumer, state, subscribe_to: [Elixirc.EventManager]}
    end

    defmacro __using__(_) do
      quote location: :keep do
        def handle_event(_command, _args, state) do
          IO.puts("shit!")
          {:ok, state}
        end

        defoverridable [handle_event: 3]
      end
    end

    def handle_events([{command, args, clientstate}], _from, module) do
      {:ok, newclientstate} = module.handle_event(command, args, clientstate)
      GenStage.cast(Elixirc.EventManager, {:update_state, newclientstate})
      {:noreply, [], module}
    end

    def handle_events(_events, _from, module) do
      {:noreply, [], module}
    end
end

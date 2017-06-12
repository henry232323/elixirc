defmodule ExampleConsumer do
    use GenStage
    alias Elixirc.Client

    def start_link do
      GenStage.start_link(__MODULE__, :state_doesnt_matter)
    end

    def init(state) do
      {:consumer, state, subscribe_to: [Elixirc.EventManager]}
    end

    def handle_events([:mode], _from, state) do
      Client.send(["JOIN", "#pesterchum"])
      {:noreply, [], state}
    end

    def handle_events(_events, _from, state) do
      {:noreply, [], state}
    end
end

defmodule Elixirc.ExampleConsumer do
    use GenStage
    alias Elixirc.Client

    def start_link do
      GenStage.start_link(__MODULE__, :ok)
    end

    def init(:ok) do
      {:consumer, :ok, subscribe_to: [Elixirc.EventManager]}
    end

    def handle_events([:mode], _from, state) do
      Client.send(["JOIN", "#pesterchum"])
      {:noreply, [:mode], state}
    end

    def handle_events(events, _from, state) do
      {:noreply, events, state}
    end
end

defmodule Elixirc.Consumer do
    use GenStage

    def start_link do
      GenStage.start_link(__MODULE__, :state)
    end

    def init(state) do
      {:consumer, state, subscribe_to: Elixirc.EventManager.Connector}
    end
end

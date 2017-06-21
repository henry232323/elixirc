defmodule Elixirc.App do
    use Application

    def start(_type, [state]) do
      Elixirc.start!(state)
    end
end

defmodule Elixirc.App do
    use Application

    def start(_type, [%{ssl?: ssl?}, host, port]) do
      Elixirc.start!(%{ssl?: ssl?}, host, port)
    end
end

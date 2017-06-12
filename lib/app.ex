defmodule Elixirc.App do
    use Application

    def start(_type, [%{ssl?: ssl?}, host, port, options]) do
      Elixirc.start!(%{ssl?: ssl?}, host, port, options)
    end
end

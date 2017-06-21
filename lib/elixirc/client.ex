defmodule Elixirc.Client do
  def send(args) do
    GenStage.cast(Elixirc.EventManager, {:send, args})
  end

  def close do
    GenStage.cast(Elixirc.EventManager, :close)
  end
end

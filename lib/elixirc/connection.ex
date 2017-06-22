defmodule Elixirc.Connection do
  require Logger

  def sock_read(socket, buffer) do
    case Elixirc.Connection.Connector.recv(socket, 0) do
      {:ok, data} ->
        buffer = buffer <> data
        [current | bfs] = String.split(buffer, "\n")
        current
        |> Logger.info
        buffer = Enum.join(bfs)
        if current do
          cmd = Elixirc.Events.parse(current)
          GenStage.cast(Elixirc.EventManager, {:command, cmd})
        end
        sock_read(socket, buffer)
      {:error, :closed} -> Elixirc.Connection.Connector.close(socket)
    end
  end
end

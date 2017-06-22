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
      {:error, error} ->
        Elixirc.Connection.Connector.close(socket)
        Logger.info("Socket has been closed: #{error}")
        GenStage.cast(Elixirc.EventManager, {:socket_closed, error})
    end
  end
end

defmodule Elixirc.Connection do
  def sock_read(socket, buffer) do
    {:ok, data} = Elixirc.Connection.Connector.recv(socket, 0)
    #IO.inspect(data)
    buffer = buffer <> data
    [current | bfs] = String.split(buffer, "\n")
    buffer = Enum.join(bfs)
    if current do
      cmd = Elixirc.Events.parse(current)
      GenStage.cast(Elixirc.EventManager, {:command, cmd})
    end
    sock_read(socket, buffer)
  end
end

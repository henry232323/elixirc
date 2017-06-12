defmodule Elixirc.Connection do
  def sock_read(socket, buffer) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    buffer = buffer <> data
    [current | bfs] = String.split(buffer, "\n")
    buffer = Enum.join(bfs)
    if current do
      GenStage.cast(Elixirc.EventManager, {:parse, current})
    end
    sock_read(socket, buffer)
  end
end

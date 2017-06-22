defmodule Elixirc.Client do
  def send(args) do
    GenStage.cast(Elixirc.EventManager, {:send, args})
  end

  def close do
    GenStage.cast(Elixirc.EventManager, :close)
  end

  def privmsg(user, args) do
    message = Enum.join(args, " ")
    send(["PRIVMSG", user, ":" <> message])
  end

  def send_nickserv(command, args) do
    privmsg("NickServ", [command | args])
  end
end

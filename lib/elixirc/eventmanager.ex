defmodule Elixirc.EventManager do
  use GenServer

  defmodule State do
    defstruct address: "",
              port: "",
              nick: "",
              name: "",
              user: "",
              pass: "",
              pinging: "",
              channels: [],
              users: [],
              socket: nil
  end

  def start_link do
    GenServer.start_link(__MODULE__, %State{}, name: EventManager)
  end

  def get_state do
    GenServer.call(IRCConnectionManager)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end

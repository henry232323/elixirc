# elixirc
[![Build Status](https://travis-ci.org/henry232323/elixirc.svg?branch=master)](https://travis-ci.org/henry232323/elixirc)
[![Hex.pm Version](http://img.shields.io/hexpm/v/exirc.svg?style=flat)](https://hex.pm/packages/elixirc)
<br />
A small lightweight Elixir IRC library based off the Python IRC library [aioyoyo](https://github.com/henry232323/aioyoyo)/oyoyo. Available on Hex.

# Example usage
```elixir
defmodule ElixircTest do
  use Supervisor
  import Supervisor.Spec

  def start(_type, _args) do
    state = %Elixirc.State{address: 'chat.freenode.net',
                           port: 6667,
                           ssl: false,
                           nick: "henry232323",
                           name: "henry232323",
                           pinging: true}
    Elixirc.start!(state)
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(TestConsumer, [:ok])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule TestConsumer do
  use Elixirc.Consumer
  alias Elixirc.Client

  def start_link(:ok) do
    Elixirc.Consumer.start_link(__MODULE__, :ok)
  end

  def handle_command(:welcome, _args, state) do
    Client.send(["JOIN", "#elixir-lang"])
    {:ok, state}
  end

  def handle_command(_command, _args, state) do
    {:ok, state}
  end
end
```
# State
Commands will pass the client state. This is the default state. Whatever state you
 pass should have at least these keys.
```elixir
defmodule Elixirc.State do
  defstruct address: "",
            port: "",
            ssl: false,
            nick: "",
            name: "",
            pass: "",
            pinging: false,
            reconnect: false,
            channels: {},
            users: %{},
            socket: nil,
            state: %{} # sub state
end
```
 - Pinging:   If this is enabled the client will automatically handle PINGs for you
 - Reconnect: If this is enabled the client will reconnect upon a closed connection by the server
 - SSL:       If this is enabled the client will connect via SSL
 - Socket:    This is the socket that the client will read from, this is automatically overwritten
 - State:     A simple 'sub-state' available within the Client's state, can be modified without breaking anything
 - Address:   The server address
 - Port:      The server port
 - Channels:  The channel list
 - Users:     The user list
 - Nick:      The nick that will be used
 - Name:      The name that will be used
 - Pass:      The password that will be used with SASL/NickServ

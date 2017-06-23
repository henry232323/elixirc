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
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
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

  def handle_command(:welcome, [message], state) do
    Client.send(["JOIN", "#elixir-lang"])
    IO.inspect("We've been welcomed with the following message: #{message}")
    {:ok, state}
  end

  def handle_command(_command, _args, state) do
    {:ok, state}
  end

  def handle_event(:send, {request}, state) do
    IO.puts("Sent message #{request}")
    {:ok, state}
  end

  def handle_event(_event, _args, state) do
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

# Handle Commands
  handle_command/3 will be called with every message sent from the server. As shown
  in the above examples it will be called first with an atom representing the command
  (usually in all caps in the message as the first argument, or if a numeric command
  is preceded by a prefix) then a list of its arguments, and finally the current state
  as defined above.

# Handle Event
  handle_event/3 will be called with every action on the part of the client and certain
  other events. It operates in the same fashion as handle_command/3 with the first
  argument being the event, the second being a tuple of its arguments and the third
  being the state. Valid events include:
    - :socket_closed    {reason}    The socket was closed for some reason
    - :close            {}          The client/socket have been closed by user
    - :send             {message}   A message has been sent to the server

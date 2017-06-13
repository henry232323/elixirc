defmodule TestConsumer do
    use Application

    def start(_type, _args) do
      state = %Elixirc.EventManager.State{address: 'irc.mindfang.org',
                                                      port: 1413,
                                                      ssl: false,
                                                      nick: "Henry",
                                                      name: "pcc31",
                                                      user: "",
                                                      pass: "",
                                                      pinging: true,
                                                      channels: [],
                                                      users: []}
      Elixirc.start!(state)
    end
end

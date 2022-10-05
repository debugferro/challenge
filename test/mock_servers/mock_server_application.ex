defmodule UtrustChallenge.Test.MockServerApplication do
  use Application

  def start(_type, _args) do
    children = [{Plug.Cowboy, scheme: :http, plug: UtrustChallenge.Test.MockServers.EtherscanServer, options: [port: 8081]}]

    opts = [strategy: :one_for_one, name: UtrustChallenge.Test.MockServers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

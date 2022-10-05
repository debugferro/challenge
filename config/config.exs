# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :utrust_challenge,
  ecto_repos: [UtrustChallenge.Repo]

# Configures the endpoint
config :utrust_challenge, UtrustChallengeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: UtrustChallengeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: UtrustChallenge.PubSub,
  live_view: [signing_salt: "db8PrVzU"]

config :utrust_challenge, :pow,
  user: UtrustChallenge.Identity.User,
  repo: UtrustChallenge.Repo,
  controller_callbacks: UtrustChallengeWeb.ControllerCallbacks

config :crawly,
  middlewares: [
    {Crawly.Middlewares.UserAgent,
     user_agents: [
       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
     ]}
  ]

config :utrust_challenge, UtrustChallenge.BlockchainExplorer.Adapter,
  ethereum_adapter: UtrustChallenge.BlockchainExplorer.Ethereum.Etherscan

config :utrust_challenge, Etherscan,
  base_api_url: System.get_env("ETHERSCAN_API_BASE_URL") || "https://api.etherscan.io/api",
  base_url: System.get_env("ETHERSCAN_BASE_URL") || "https://etherscan.io",
  api_key: System.get_env("ETHERSCAN_API_KEY")

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :utrust_challenge, UtrustChallenge.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

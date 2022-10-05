import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :utrust_challenge, UtrustChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "utrust_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_primary_key: [name: :id, type: :binary_id],
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :utrust_challenge, UtrustChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KotEQm48DSvv0k4kH6Z1sKMWL71EX0CrjnXx52x/kx52iGx6oznConHwPS1Xa0HP",
  server: false

config :utrust_challenge, Etherscan,
  base_api_url: "http://localhost:8081/api",
  base_url: "http://localhost:8081",
  api_key: "12345"

# In test we don't send emails.
config :utrust_challenge, UtrustChallenge.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

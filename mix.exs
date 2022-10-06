defmodule UtrustChallenge.MixProject do
  use Mix.Project

  def project do
    [
      app: :utrust_challenge,
      version: "0.1.0",
      elixir: "~> 1.14.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {UtrustChallenge.Application, []},
      extra_applications: [:logger, :runtime_tools],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/mock_servers"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.6.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:pow, "~> 1.0.27"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.10"},
      {:gettext, "~> 0.18"},
      {:crawly, "~> 0.14.0"},
      {:timex, "~> 3.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:phoenix_html_simplified_helpers, "~> 2.1"},
      {:floki, "~> 0.33.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end

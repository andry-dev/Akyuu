defmodule Akyuu.MixProject do
  use Mix.Project

  def project do
    [
      app: :akyuu,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "Akyuu",
      source_url: "https://github.com/andry-dev/Akyuu",
      docs: [
        main: "Akyuu",
        logo: "assets/static/images/akyuu_vinyl.svg",
        extras: ["README.md"],
        groups_for_modules: [
          "Doujin music": [Akyuu.Music, ~r"^Akyuu.Music..*"],
          Accounts: [Akyuu.Accounts, ~r"^Akyuu.Accounts..*"],
          Web: [~r"^AkyuuWeb.*"]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Akyuu.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:credo, "~> 1.5.0-rc.4", only: [:dev, :test], runtime: false},
      # {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false},
      {:phoenix, "~> 1.5"},
      {:phoenix_ecto, "~> 4.2"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      # {:myxql, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:argon2_elixir, "~> 1.3"},
      {:pow, "~> 1.0"},
      {:pow_assent, "~> 0.4"},
      {:surface, git: "https://github.com/msaraiva/surface.git", tag: "v0.1.0-rc.1"},
      {:waffle, "~> 1.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end

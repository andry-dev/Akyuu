# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :akyuu,
  ecto_repos: [Akyuu.Repo]

# Configures the endpoint
config :akyuu, AkyuuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q7CCAnsHdPAAo/KWZJtPpkqSa3MhtwBEbi/ag/rE25A9V7/TM5xWU8hRjOjFlLQ/",
  render_errors: [view: AkyuuWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Akyuu.PubSub,
  live_view: [signing_salt: "AJqe7dNE"]

config :akyuu, :pow,
  repo: Akyuu.Repo,
  user: Akyuu.Accounts.User,
  web_module: AkyuuWeb,
  # extensions: [],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

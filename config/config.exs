# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :peridot,
  ecto_repos: [Peridot.Repo]

# Configures the endpoint
config :peridot, PeridotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KTfAyebqt9g5c6bkCt2ej/qCL0eW2DDHbMzsyXnJFall5ZLunOoSDHU3wvlK1kfN",
  render_errors: [view: PeridotWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Peridot.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
     signing_salt: "lA85+Kg+uvHCBtz+B+7OnDP9ha+I36mk"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

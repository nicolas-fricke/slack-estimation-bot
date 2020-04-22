# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :slack_estimations,
  ecto_repos: [SlackEstimations.Repo]

# Configures the endpoint
config :slack_estimations, SlackEstimationsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nZVTJ2kMAIVKsFu58t/r7+TfKeoKgJzVbacjooXayDAy9N2OwCCeZAJM6p8VO3sn",
  render_errors: [view: SlackEstimationsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackEstimations.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "JHAJtwNX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

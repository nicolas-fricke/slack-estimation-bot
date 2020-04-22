defmodule SlackEstimations.Repo do
  use Ecto.Repo,
    otp_app: :slack_estimations,
    adapter: Ecto.Adapters.Postgres
end

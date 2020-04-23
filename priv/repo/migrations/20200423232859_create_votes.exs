defmodule SlackEstimations.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :message_id, :string
      add :user_handle, :string
      add :vote, :integer

      timestamps()
    end

  end
end

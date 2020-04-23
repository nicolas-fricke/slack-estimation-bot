defmodule SlackEstimations.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :message_id, :string
    field :user_handle, :string
    field :vote, :integer

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:message_id, :user_handle, :vote])
    |> validate_required([:message_id, :user_handle, :vote])
  end
end

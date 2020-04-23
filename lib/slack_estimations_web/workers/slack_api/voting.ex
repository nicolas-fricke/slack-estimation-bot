defmodule SlackEstimationsWeb.SlackApi.Voting do
  require Ecto.Query

  def handle_vote_async(user_handle, data) do
    Task.start fn -> handle_vote(user_handle, data) end
  end

  def handle_vote(user_handle, data) do
    vote = extract_vote(data)
    message_id = generate_message_id(data)
    track_vote(message_id, user_handle, vote)
    update_message(message_id, data)
  end

  defp extract_vote(%{"actions" => actions}) do
    actions
    |> hd
    |> Map.get("text")
    |> Map.get("text")
    |> String.to_integer
  end

  defp extract_response_url(%{"response_url" => response_url}), do: response_url
  defp generate_message_id(%{"channel" => %{"id" => channel_id}, "message" => %{"ts" => timestamp}}) do
    "#{channel_id}-#{timestamp}"
  end

  defp track_vote(message_id, user_handle, vote) do
    Ecto.Query.from(
      v in SlackEstimations.Vote,
      where: v.message_id == ^message_id,
      where: v.user_handle == ^user_handle
    ) |> SlackEstimations.Repo.delete_all

    %SlackEstimations.Vote{
      message_id: message_id,
      user_handle: user_handle,
      vote: vote
    } |> SlackEstimations.Repo.insert
  end

  defp update_message(message_id, data) do
    url = extract_response_url(data)

    blocks =
      data["message"]["blocks"]
      |> Enum.drop(-1)
      |> List.insert_at(-1, build_updated_votes_block(message_id))

    message = %{data["message"] | "blocks" => blocks}

    SlackEstimationsWeb.SlackApi.PostRequest.execute(url, message)
  end

  defp build_updated_votes_block(message_id) do
    users = Ecto.Query.from(
      v in SlackEstimations.Vote,
      where: v.message_id == ^message_id,
      select: v.user_handle
    ) |> SlackEstimations.Repo.all

    %{
      type: :section,
      text: %{
        type: :mrkdwn,
        text: "Votes so far from: #{Enum.join(users, ", ")}",
      },
    }
  end
end

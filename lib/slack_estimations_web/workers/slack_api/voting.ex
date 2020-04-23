defmodule SlackEstimationsWeb.SlackApi.Voting do
  def handle_vote_async(user_handle, data) do
    Task.start fn -> handle_vote(user_handle, data) end
  end

  def handle_vote(user_handle, data) do
    vote = extract_vote(data)
    track_vote(user_handle, vote)
    update_message(user_handle, data)
  end

  defp extract_vote(%{"actions" => actions}) do
    actions
    |> hd
    |> Map.get("text")
    |> Map.get("text")
  end

  defp extract_response_url(%{"response_url" => response_url}), do: response_url

  defp track_vote(user_handle, vote) do
    # TODO: Properly track this user's vote
    IO.puts "#{user_handle} voted #{vote}"
  end

  defp update_message(user_handle, data) do
    url = extract_response_url(data)

    blocks =
      data["message"]["blocks"]
      |> Enum.drop(-1)
      |> List.insert_at(-1, build_updated_votes_block(user_handle))

    message = %{data["message"] | "blocks" => blocks}

    SlackEstimationsWeb.SlackApi.PostRequest.execute(url, message)
  end

  defp build_updated_votes_block(user_handle) do
    users = [user_handle]

    %{
      type: :section,
      text: %{
        type: :mrkdwn,
        text: "Votes so far from: #{Enum.join(users, ", ")}",
      },
    }
  end
end

defmodule SlackEstimationsWeb.SlackApi.ShowResults do
  require Ecto.Query

  def handle_end_async(user_handle, data) do
    Task.start fn -> handle_end(user_handle, data) end
  end

  defp handle_end(user_handle, data) do
    message_id = generate_message_id(data)
    update_message(message_id, user_handle, data)
  end

  defp extract_response_url(%{"response_url" => response_url}), do: response_url
  defp generate_message_id(%{"channel" => %{"id" => channel_id}, "message" => %{"ts" => timestamp}}) do
    "#{channel_id}-#{timestamp}"
  end

  defp update_message(message_id, user_handle, data) do
    url = extract_response_url(data)

    blocks =
      data["message"]["blocks"]
      |> Enum.drop(-1)
      |> Enum.drop(-1)
    blocks = blocks ++ build_resume_blocks(message_id, user_handle)

    message = %{data["message"] | "blocks" => blocks}

    SlackEstimationsWeb.SlackApi.PostRequest.execute(url, message)
  end

  defp get_votes(message_id) do
    votes = Ecto.Query.from(
      v in SlackEstimations.Vote,
      where: v.message_id == ^message_id
    )
    |> SlackEstimations.Repo.all

    reducer = fn(row, acc) ->
      acc = Map.put_new(acc, row.vote, [])
      Map.put(acc, row.vote, acc[row.vote] ++ [row.user_handle])
    end

    Enum.reduce(votes, %{}, reducer)
  end

  defp emoji_for_vote(vote) do
    %{
      1 => :":one:",
      2 => :":two:",
      3 => :":three:",
      5 => :":five:",
      8 => :":eight:",
    }[vote]
  end

  defp build_resume_blocks(message_id, user_handle) do
    votes = get_votes(message_id)

    [
      %{
        type: :section,
        text: %{
          type: :mrkdwn,
          text: "The voting has been closed by #{user_handle}. Here are the results:"
        },
      },
      %{
        type: :section,
        fields:
          Enum.map(votes, fn({vote, users}) ->
            %{
              type: :mrkdwn,
              text: "#{emoji_for_vote(vote)} x #{length(users)} _(#{Enum.join(users, ", ")})_",
            }
          end
          )
      }
    ]
  end
end

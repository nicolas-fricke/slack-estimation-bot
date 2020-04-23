defmodule SlackEstimationsWeb.SlackApi.ActionsController do
  use SlackEstimationsWeb, :controller

  def receive(conn, %{"payload" => payload}) do
    data = Jason.decode!(payload)

    IO.inspect data

    action = extract_action(data)
    user_handle = extract_user_handle(data)

    handle_action(action, user_handle, data)

    conn
    |> send_resp(201, "")
  end

  defp extract_action(%{"actions" => actions}), do: actions |> hd
  defp extract_user_handle(%{"user" => %{"id" => user_id}}), do: "<@#{user_id}>"

  defp handle_action(%{"type" => "button", "value" => "vote"}, user_handle, data) do
    SlackEstimationsWeb.SlackApi.Voting.handle_vote_async(user_handle, data)
  end

  defp handle_action(%{"type" => "button", "value" => "end_voting"}, user_handle, data) do
    IO.puts "#{user_handle} ENDED VOTING"
  end
end

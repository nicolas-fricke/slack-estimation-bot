defmodule SlackEstimationsWeb.SlackApi.CommandsController do
  use SlackEstimationsWeb, :controller

  def receive(conn, %{"command" => "/estimate", "channel_id" => channel_id, "text" => text}) do
    SlackEstimationsWeb.SlackApi.EstimationMessageSender
      .send_message_async(channel_id, text)

    render(conn, "estimate.text", %{})
  end
end

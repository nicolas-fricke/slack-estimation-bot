defmodule SlackEstimationsWeb.SlackApi.CommandsController do
  use SlackEstimationsWeb, :controller

  def receive(conn, %{"command" => "/estimate", "channel_id" => channel_id, "text" => text}) do
    render(conn, "estimate.text", %{})
  end
end

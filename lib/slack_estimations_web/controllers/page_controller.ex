defmodule SlackEstimationsWeb.PageController do
  use SlackEstimationsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

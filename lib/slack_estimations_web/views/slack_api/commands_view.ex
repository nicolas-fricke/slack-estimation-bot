defmodule SlackEstimationsWeb.SlackApi.CommandsView do
  use SlackEstimationsWeb, :view

  def render("estimate.text", _data) do
    "Let me fetch some data to get the estimation started..."
  end
end

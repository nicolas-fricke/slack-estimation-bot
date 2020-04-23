defmodule SlackEstimationsWeb.SlackApi.PostRequest do
  def execute(url, body) do
    headers = %{
      "Content-Type" => "application/json; charset=utf-8",
      "Authorization" => "Bearer #{System.fetch_env!("SLACK_TOKEN")}"
    }
    json_body = Jason.encode!(body)
    HTTPoison.post(url, json_body, headers)
  end
end

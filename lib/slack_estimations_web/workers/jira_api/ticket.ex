defmodule SlackEstimationsWeb.JiraApi.Ticket do
  defstruct number: "?", title: "_Could not fetch ticket_", type: "?", status: "?"

  def fetch(ticket_number) do
    headers = %{
      "Content-Type" => "application/json; charset=utf-8",
    }
    url = "https://jira.atlassian.com/rest/api/latest/issue/#{ticket_number}"

    {:ok, response} = HTTPoison.get(url, headers)

    process_response(response)
  end

  defp process_response(response = %{status_code: 200}) do
    data = Jason.decode!(response.body)

    ticket = %__MODULE__{
      number: data["key"],
      title: get_in(data, ["fields", "summary"]),
      type: get_in(data, ["fields", "issuetype", "name"]),
      status: get_in(data, ["fields", "status", "name"]),
    }

    {:ok, ticket}
  end

  defp process_response(_) do
    {:error, %__MODULE__{}}
  end
end

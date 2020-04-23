defmodule SlackEstimationsWeb.SlackApi.EstimationMessageSender do
  def send_message_async(channel_id, text) do
    Task.start fn -> __MODULE__.send_message(channel_id, text) end
  end

  def send_message(channel_id, text) do
    body = build_body(channel_id, text)
    url = "https://slack.com/api/chat.postMessage"
    SlackEstimationsWeb.SlackApi.PostRequest.execute(url, body)
  end

  defp extract_ticket_number(text) do
    text |>
      String.split("/") |>
      List.last
  end

  defp build_body(channel_id, text) do
    # TODO: Replace this with actual data from Jira
    ticket_number = extract_ticket_number(text)
    jira_link = "https://robohash.org/#{ticket_number}"
    ticket_data = %{
      type: "Bug",
      status: "Open",
      title: "Add a Hello to the World",
    }

    %{
      channel: channel_id,
      text: "Time to estimate #{ticket_number}!",
      blocks: [
        %{
          type: :section,
          text: %{
            type: :mrkdwn,
            text: "Let's estimate: _#{ticket_number}_",
          },
        },
        %{
          type: :section,
          fields: [
            %{
              type: :mrkdwn,
              text: "*Type:* #{ticket_data.type}",
            },
            %{
              type: :mrkdwn,
              text: "*Status*: #{ticket_data.status}",
            },
          ]
        },
        %{
          type: :section,
          text: %{
            type: :mrkdwn,
            text: ":page_with_curl: <#{jira_link}|*#{ticket_data.title}*>",
          },
          accessory: %{
            type: :button,
            text: %{
              type: :plain_text,
              text: "Open on Jira",
            },
            url: jira_link,
          },
        },
        %{
          type: :actions,
          block_id: :actionblock_voting,
          elements: [
            build_vote_button(1),
            build_vote_button(2),
            build_vote_button(3),
            build_vote_button(5),
            build_vote_button(8),
            %{
              type: :button,
              text: %{
                type: :plain_text,
                text: "End voting",
              },
              style: :danger,
              value: :end_voting,
            },
          ],
        },
        %{
          type: :section,
          text: %{
            type: :mrkdwn,
            text: "Nobody voted yet...",
          },
        }
      ],
    }
  end

  defp build_vote_button(number) do
    %{
      type: :button,
      text: %{
        type: :plain_text,
        text: "#{number}",
      },
      style: :primary,
      value: :vote,
    }
  end
end

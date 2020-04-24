# SlackEstimations

This project was created as part of the Xing Hackweek #15.

The idea is to make **scrum estimation sesstions more remote friendly**. Therefore, this is a Slackbot built with Elixir & Phoenix that reacts to `/estimate JIRA-123` commands on Slack channels and shows an estimation modal to all users.

## Demo

This is what the bot can look like in action:

![Let's see it in action](https://user-images.githubusercontent.com/1423331/80205459-ed86bc00-862a-11ea-9497-d0c2f4e06273.gif)

As you can see, you can start it by using the _Slash command_ `/estimate` followed by the ticket number you want to estimate.

This then posts a public message to the channel with some detail of the ticket and allows everyone in the channel to cast their votes.
Users can use the normal Slack thread on the message to discuss the ticket.
After everyone has cast their vote, you can click _"End voting"_ which will trigger the results to be shown.

All users can see how everyone else voted and the results can e.g. be further discussed in the thread.
Then, you can update the Jira ticket accordingly and go on with your life.
Easy as pie :)

## Caveats

As this was a hackweek project, it is still quite rough around the edges:

* This project is currently utterly untested and really not ready for prime time
* It's also my first project to ever use Elixir, Phoenix, or write a Slack bot at all
* Since the app is not yet published to the Slack store (and the code also isn't quite in shape for us to do so yet), you need to manually set up a Slack app and link it to the server
* One server currently only supports one Slack instance
* The Jira server is currently hard-coded against the public Atlassian Jira issue tracker. This needs to be changed for each project.

## Setup

### Configure a Slack app

As mentioned before, this app is not yet published to the official Slack App repository.
Therefore, to use it, you'll have to set up a custom Slack App and set up your server to use its credentials.
You'll also need to point the App URLs to your own server.

1. Go to https://api.slack.com/apps and create a new Slack app
1. Start by configuring a Slash command in the _Slash Commands_ sidebar option
   - Create a new command `/estimate`
   - Fill in any URL for now. We'll change this once we have our server running.
   - Provide some description and usage hint
1. Next, go to _Interactivity & Shortcuts_ to enable support for the button responses
   - Switch the _Interactivity_ toggle to `on`
   - Fill in any URL for now. We'll again change this once we have our server running
1. Now we have to grant some permissions to our app
   - Go to the _OAuth & Permissions_ sidebar link
   - Scroll down to _Scopes_
   - Add the `chat:write`, `chat:write.customize`, `chat:write.public`, and `commands` scopes
1. Finally, go to the _Install App_ sidebar link to install your app to your workspace
   - Copy the _Bot User OAuth Access Token_ as we'll need it to set the `SLACK_TOKEN` environment variable on our server to it

### Server

The code is currently set up to be hosted on [Gigalixir](https://gigalixir.com/).
This is a platform similar to Heroku but focussed on Elixir apps.
It also provides a free tier which is a great point to start with an app like this.

[This Elixircast](https://elixircasts.io/deploying-with-gigalixir-%28revised%29) provides a great introduction to Gigalixir.

In short, go to [gigalixir.com](https://gigalixir.com/) to create an account.
Then install the `gigalixir` cli locally on your machine via
```
$ pip install gigalixir
```

Next, you'll need to log in to your account with
```
$ gigalixir login
```

And then create a new app in the free tier
```
$ gigalixir create
```

Now, you'll need to set up a Postgres DB for your app and set an environment variable to keep the pool size to two (maximum in the free tier)
```
$ gigalixir pg:create --free
$ gigalixir config:set POOL_SIZE=2
```

Lastly, you'll need to configure your server with your Slack token from above
```
$ gigalixir config:set SLACK_TOKEN="<your token>"
```

The `gigalixir create` command registered a new `git` branch for you that you can push to to deploy your app.
Let's do this now:
```
$ git push gigalixir master
```

After this is done, make sure to copy the URL to your app from the output.

### Point Slack App to Gigalixir server

Now, we'll need to tie our server and the Slack App together.

For this, go back to the Slack App config page and first navigate to _Slash Commands_ -> `/estimate` command.
Set its _Request URL_ to the HTTPS host you copied from the step before followed by `/slack/commands`.
It should look something like `https://khaki-unique-pterosaurs.gigalixirapp.com/slack/commands`.

Then, go to the _Interactivity & Shortcuts_ section and set this _Request URL_ to the same host followed by `/slack/actions`.
It should be something similar to `https://khaki-unique-pterosaurs.gigalixirapp.com/slack/actions`.

### Give it a try

Everything should be set up!
Go to your Slack instance and type something like `/estimate JRASERVER-70953` to estimate your first ticket.

## Local development

For local development, follow the steps above to create a Slack App that you'll use for testing.

Then start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and should see a default Phoenix landing page.
This tells you that your server is up and running.

To be able to receive the callbacks from Slack, you'll need to expose your local server to the internet.
To do so, you can e.g. use [ngrok](https://ngrok.com/).
Once installed, run `ngrok http 4000` and use the `https://<your-id>.ngrok.io` URL as host for the Slack setup.

Set the command callback to go to `https://<your-id>.ngrok.io/slack/commands` and the interactivity callback to go to `https://<your-id>.ngrok.io/slack/actions`.

Now you should be able to go to the Slack instance where you installed your Slack App and issue `/estimate TICKET-123`.
You should see in `ngrok` that the calls arrive at your local machine and the Phoenix logs should register the incoming request.
Slack should then receive the estimation message and allow users to vote.

## Learn more

  * Intro to Elixir: https://elixir-lang.org/getting-started/
  * Elixir Casts: https://elixircasts.io/
  * Official Phoenix website: https://www.phoenixframework.org/
  * Phoenix Guides: https://hexdocs.pm/phoenix/overview.html
  * Slack Documentation: https://api.slack.com/messaging/managing

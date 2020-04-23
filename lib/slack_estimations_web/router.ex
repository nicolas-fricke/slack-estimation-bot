defmodule SlackEstimationsWeb.Router do
  use SlackEstimationsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :slack do
    plug :accepts, ["json"]
  end

  scope "/", SlackEstimationsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/slack", SlackEstimationsWeb.SlackApi do
    pipe_through :api

    post "/commands", CommandsController, :receive
  end

  # Other scopes may use custom stacks.
  # scope "/api", SlackEstimationsWeb do
  #   pipe_through :api
  # end
end

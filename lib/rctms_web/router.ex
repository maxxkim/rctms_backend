# lib/rctms_web/router.ex
defmodule RCTMSWeb.Router do
  use RCTMSWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug RCTMSWeb.Schema.Context
  end

  # Remove all REST API endpoints
  # scope "/api", RCTMSWeb do
  #   pipe_through :api
  #   ...
  # end

  # Keep only GraphQL endpoints
  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/graphql", Absinthe.Plug,
      schema: RCTMSWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: RCTMSWeb.Schema,
      socket: RCTMSWeb.UserSocket,
      interface: :playground
  end
end

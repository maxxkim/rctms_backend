defmodule RCTMSWeb.Router do
  use RCTMSWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug RCTMSWeb.Schema.Context
  end

  # Keep only the GraphQL routes
  scope "/api" do
    pipe_through :api

    # GraphQL endpoint
    forward "/graphql", Absinthe.Plug,
      schema: RCTMSWeb.Schema

    # GraphiQL playground (for development)
    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: RCTMSWeb.Schema,
        interface: :playground,
        socket: RCTMSWeb.UserSocket
    end
  end

  # If you have any browser-related routes, you can keep them
  # Otherwise, you can remove the browser pipeline and routes too
end

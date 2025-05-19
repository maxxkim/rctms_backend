# lib/rctms/application.ex
defmodule RCTMS.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RCTMSWeb.Telemetry,
      # Start the Ecto repository
      RCTMS.Repo,
      # Start the PubSub system with a name
      {Phoenix.PubSub, name: RCTMS.PubSub},
      # Start Finch
      {Finch, name: RCTMS.Finch},
      # Start the Endpoint (http/https)
      RCTMSWeb.Endpoint,
      # Start a worker by calling: RCTMS.Worker.start_link(arg)
      # {RCTMS.Worker, arg}

      # Add Absinthe's subscription
      {Absinthe.Subscription, RCTMSWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RCTMS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RCTMSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

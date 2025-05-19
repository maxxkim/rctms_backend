defmodule RCTMS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RCTMSWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RCTMS.PubSub},
      # Start Finch
      {Finch, name: RCTMS.Finch},
      # Start the Ecto repository
      RCTMS.Repo,
      # Start the endpoint when the application starts
      RCTMSWeb.Endpoint,
      # Start the presence tracker
      RCTMSWeb.Presence,
      # Start a supervisor for dynamic creation of task buckets
      {DynamicSupervisor, name: RCTMS.TaskSupervisor, strategy: :one_for_one}
      # Add any other supervisors or workers here
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

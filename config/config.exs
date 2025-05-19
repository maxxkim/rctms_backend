# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rctms,
  namespace: RCTMS,
  ecto_repos: [RCTMS.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :rctms, RCTMSWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: RCTMSWeb.ErrorHTML, json: RCTMSWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RCTMS.PubSub,
  live_view: [signing_salt: "mdfr9AQv"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :rctms, RCTMS.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  rctms: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  rctms: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
# Guardian configuration for authentication
config :rctms, RCTMS.Accounts.Guardian,
  issuer: "rctms",
  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"
  # In production, you'd put this in runtime.exs and fetch from environment variables:
  # secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Configure Absinthe for GraphQL
config :absinthe,
  adapter: Absinthe.Adapter.LanguageConventions

# Configure Phoenix generators
config :phoenix, :json_library, Jason

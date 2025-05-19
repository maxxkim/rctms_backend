# Project Knowledge Base
Generated on Mon May 19 15:05:41 MSK 2025

## Table of Contents
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Database Schema](#database-schema)
- [Controllers](#controllers)
- [Models](#models)
- [LiveView Components](#liveview-components)
- [GraphQL Schema](#graphql-schema)
- [Channels](#channels)
- [GenServers and Supervisors](#genservers-and-supervisors)
- [Tests](#tests)

## Project Structure
```
./.formatter.exs
./config/config.exs
./config/dev.exs
./config/prod.exs
./config/runtime.exs
./config/test.exs
./lib/rctms_web.ex
./lib/rctms_web/channels/presence.ex
./lib/rctms_web/channels/project_channel.ex
./lib/rctms_web/channels/user_socket.ex
./lib/rctms_web/components/core_components.ex
./lib/rctms_web/components/layouts.ex
./lib/rctms_web/components/layouts/app.html.heex
./lib/rctms_web/components/layouts/root.html.heex
./lib/rctms_web/controllers/comment_controller.ex
./lib/rctms_web/controllers/comment_json.ex
./lib/rctms_web/controllers/error_html.ex
./lib/rctms_web/controllers/error_json.ex
./lib/rctms_web/controllers/fallback_controller.ex
./lib/rctms_web/controllers/page_controller.ex
./lib/rctms_web/controllers/page_html.ex
./lib/rctms_web/controllers/page_html/home.html.heex
./lib/rctms_web/controllers/project_controller.ex
./lib/rctms_web/controllers/project_json.ex
./lib/rctms_web/controllers/task_controller.ex
./lib/rctms_web/controllers/task_json.ex
./lib/rctms_web/controllers/user_controller.ex
./lib/rctms_web/controllers/user_json.ex
./lib/rctms_web/endpoint.ex
./lib/rctms_web/gettext.ex
./lib/rctms_web/router.ex
./lib/rctms_web/schema/context.ex
./lib/rctms_web/schema/query_testy.exs
./lib/rctms_web/schema/resolvers/comment_resolver.ex
./lib/rctms_web/schema/resolvers/project_resolver.ex
./lib/rctms_web/schema/resolvers/task_resolver.ex
./lib/rctms_web/schema/resolvers/user_resolver.ex
./lib/rctms_web/schema/schema.ex
./lib/rctms_web/schema/types/comment.ex
./lib/rctms_web/schema/types/project.ex
./lib/rctms_web/schema/types/task.ex
./lib/rctms_web/schema/types/user.ex
./lib/rctms_web/telemetry.ex
./lib/rctms_web/views/changeset_view.ex
./lib/rctms.ex
./lib/rctms/accounts.ex
./lib/rctms/accounts/error_handler.ex
./lib/rctms/accounts/guardian.ex
./lib/rctms/accounts/pipeline.ex
./lib/rctms/accounts/user.ex
./lib/rctms/application.ex
./lib/rctms/collaboration.ex
./lib/rctms/collaboration/comment.ex
./lib/rctms/mailer.ex
./lib/rctms/projects.ex
./lib/rctms/projects/project.ex
./lib/rctms/repo.ex
./lib/rctms/tasks.ex
./lib/rctms/tasks/task.ex
./mix.exs
./priv/repo/migrations/.formatter.exs
./priv/repo/migrations/20250515132802_create_users.exs
./priv/repo/migrations/20250515132814_create_projects.exs
./priv/repo/migrations/20250515132828_create_tasks.exs
./priv/repo/migrations/20250515132836_create_comments.exs
./priv/repo/seeds.exs
./test/rctms_web/controllers/error_html_test.exs
./test/rctms_web/controllers/error_json_test.exs
./test/rctms_web/controllers/page_controller_test.exs
./test/support/conn_case.ex
./test/support/data_case.ex
./test/test_helper.exs
```

## Configuration
### mix.exs
```elixir
defmodule RCTMS.MixProject do
  use Mix.Project

  def project do
    [
      app: :rctms,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RCTMS.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.21"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:guardian, "~> 2.3"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:absinthe_relay, "~> 1.5"},
      {:dataloader, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "phx.server": ["phx.server"]
      ]
    ]
  end
end
```

### Configuration Files
#### config.exs
```elixir
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
```

#### dev.exs
```elixir
import Config

# Configure your database
config :rctms, RCTMS.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rctms_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :rctms, RCTMSWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Gfg8lZYVSRqh3+PBxNmP/dxbTkvdTLy57EvvQDWMPqRKqUZSrLpWWqfnmHU0b80q",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:rctms, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:rctms, ~w(--watch)]}
  ]


config :rctms, RCTMSWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/rctms_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :rctms, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
```

#### prod.exs
```elixir
import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :rctms, RCTMSWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: RCTMS.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
```

#### runtime.exs
```elixir
import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/rctms start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :rctms, RCTMSWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :rctms, RCTMS.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :rctms, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :rctms, RCTMSWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :rctms, RCTMSWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your config/prod.exs,
  # ensuring no data is ever sent via http, always redirecting to https:
  #
  #     config :rctms, RCTMSWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :rctms, RCTMS.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
```

## Database Schema
### Migrations
#### .formatter.exs
```elixir
[
  import_deps: [:ecto_sql],
  inputs: ["*.exs"]
]
```

#### 20250515132802_create_users.exs
```elixir
defmodule RCTMS.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
```

#### 20250515132814_create_projects.exs
```elixir
defmodule RCTMS.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :text
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:owner_id])
  end
end
```

#### 20250515132828_create_tasks.exs
```elixir
# priv/repo/migrations/TIMESTAMP_create_tasks.exs
defmodule RCTMS.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :string, null: false, default: "pending"
      add :priority, :string, null: false, default: "medium"
      add :due_date, :utc_datetime
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :assignee_id, references(:users, on_delete: :nilify_all)
      add :creator_id, references(:users, on_delete: :nilify_all), null: false

      timestamps()
    end

    create index(:tasks, [:project_id])
    create index(:tasks, [:assignee_id])
    create index(:tasks, [:creator_id])
  end
end
```

#### 20250515132836_create_comments.exs
```elixir
defmodule RCTMS.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :task_id, references(:tasks, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:task_id])
    create index(:comments, [:user_id])
  end
end
```

### Schema Files
#### user.ex
```elixir
# lib/rctms_web/schema/types/user.ex
defmodule RCTMSWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  @desc "User information"
  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "User authentication result"
  object :auth_result do
    field :user, :user
    field :token, :string
  end

  # Input objects for mutations
  input_object :user_registration_input do
    field :email, non_null(:string)
    field :username, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :user_login_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  # User Mutations
  object :user_mutations do
    @desc "Register a new user"
    field :register, :auth_result do
      arg :input, non_null(:user_registration_input)
      resolve &RCTMSWeb.Resolvers.UserResolver.register/2
    end

    @desc "Login a user"
    field :login, :auth_result do
      arg :input, non_null(:user_login_input)
      resolve &RCTMSWeb.Resolvers.UserResolver.login/2
    end
  end

  # User Queries
  object :user_queries do
    @desc "Get the currently authenticated user"
    field :me, :user do
      resolve &RCTMSWeb.Resolvers.UserResolver.me/2
    end
  end
end
```

#### task.ex
```elixir
defmodule RCTMSWeb.Schema.Types.Task do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Task status enum"
  enum :task_status do
    value :pending, description: "Task has not been started"
    value :in_progress, description: "Task is currently being worked on"
    value :completed, description: "Task has been completed"
  end

  @desc "Task priority enum"
  enum :task_priority do
    value :low, description: "Low priority task"
    value :medium, description: "Medium priority task"
    value :high, description: "High priority task"
  end

  @desc "Task information"
  object :task do
    field :id, :id
    field :title, :string
    field :description, :string
    field :status, :task_status
    field :priority, :task_priority
    field :due_date, :datetime

    # Relationships
    field :project, :project do
      resolve dataloader(RCTMS.Projects)
    end

    field :assignee, :user do
      resolve dataloader(RCTMS.Accounts)
    end

    field :creator, :user do
      resolve dataloader(RCTMS.Accounts)
    end

    field :comments, list_of(:comment) do
      resolve dataloader(RCTMS.Collaboration)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  # Input objects for mutations
  input_object :task_input do
    field :title, non_null(:string)
    field :description, :string
    field :status, :task_status, default_value: :pending
    field :priority, :task_priority, default_value: :medium
    field :due_date, :datetime
    field :project_id, non_null(:id)
    field :assignee_id, :id
  end

  input_object :task_update_input do
    field :title, :string
    field :description, :string
    field :status, :task_status
    field :priority, :task_priority
    field :due_date, :datetime
    field :assignee_id, :id
  end

  # Task Queries
  object :task_queries do
    @desc "Get a specific task"
    field :task, :task do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.TaskResolver.get_task/2
    end

    @desc "List all tasks for a project"
    field :project_tasks, list_of(:task) do
      arg :project_id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.TaskResolver.list_project_tasks/2
    end

    @desc "List tasks assigned to current user"
    field :my_tasks, list_of(:task) do
      resolve &RCTMSWeb.Resolvers.TaskResolver.list_my_tasks/2
    end
  end

  # Task Mutations
  object :task_mutations do
    @desc "Create a new task"
    field :create_task, :task do
      arg :input, non_null(:task_input)
      resolve &RCTMSWeb.Resolvers.TaskResolver.create_task/2
    end

    @desc "Update a task"
    field :update_task, :task do
      arg :id, non_null(:id)
      arg :input, non_null(:task_update_input)
      resolve &RCTMSWeb.Resolvers.TaskResolver.update_task/2
    end

    @desc "Delete a task"
    field :delete_task, :task do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.TaskResolver.delete_task/2
    end
  end

  # Task Subscriptions
  object :task_subscriptions do
    @desc "Subscribe to task updates"
    field :task_updated, :task do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger [:update_task], topic: fn
        %{id: id} -> [id]
        _ -> []
      end

      resolve fn task, _, _ ->
        {:ok, task}
      end
    end

    @desc "Subscribe to new tasks in a project"
    field :task_created, :task do
      arg :project_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.project_id}
      end

      trigger [:create_task], topic: fn
        %{project_id: project_id} -> [project_id]
        _ -> []
      end

      resolve fn task, _, _ ->
        {:ok, task}
      end
    end
  end
end
```

#### comment.ex
```elixir
defmodule RCTMSWeb.Schema.Types.Comment do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Comment information"
  object :comment do
    field :id, :id
    field :content, :string

    # Relationships
    field :task, :task do
      resolve dataloader(RCTMS.Tasks)
    end

    field :user, :user do
      resolve dataloader(RCTMS.Accounts)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  # Input objects for mutations
  input_object :comment_input do
    field :content, non_null(:string)
    field :task_id, non_null(:id)
  end

  # Comment Queries
  object :comment_queries do
    @desc "Get a specific comment"
    field :comment, :comment do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.get_comment/2
    end

    @desc "List comments for a task"
    field :task_comments, list_of(:comment) do
      arg :task_id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.list_task_comments/2
    end
  end

  # Comment Mutations
  object :comment_mutations do
    @desc "Create a new comment"
    field :create_comment, :comment do
      arg :input, non_null(:comment_input)
      resolve &RCTMSWeb.Resolvers.CommentResolver.create_comment/2
    end

    @desc "Update a comment"
    field :update_comment, :comment do
      arg :id, non_null(:id)
      arg :content, non_null(:string)
      resolve &RCTMSWeb.Resolvers.CommentResolver.update_comment/2
    end

    @desc "Delete a comment"
    field :delete_comment, :comment do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.delete_comment/2
    end
  end

  # Comment Subscriptions
  object :comment_subscriptions do
    @desc "Subscribe to new comments on a task"
    field :comment_added, :comment do
      arg :task_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.task_id}
      end

      trigger [:create_comment], topic: fn
        %{task_id: task_id} -> [task_id]
        _ -> []
      end

      resolve fn comment, _, _ ->
        {:ok, comment}
      end
    end
  end
end
```

#### project.ex
```elixir
defmodule RCTMSWeb.Schema.Types.Project do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Project information"
  object :project do
    field :id, :id
    field :name, :string
    field :description, :string

    # Relationships
    field :owner, :user do
      resolve dataloader(RCTMS.Accounts)
    end

    field :tasks, list_of(:task) do
      resolve dataloader(RCTMS.Tasks)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  # Input objects for mutations
  input_object :project_input do
    field :name, non_null(:string)
    field :description, :string
  end

  # Project Queries
  object :project_queries do
    @desc "Get a specific project"
    field :project, :project do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.ProjectResolver.get_project/2
    end

    @desc "List all projects for the current user"
    field :projects, list_of(:project) do
      resolve &RCTMSWeb.Resolvers.ProjectResolver.list_projects/2
    end
  end

  # Project Mutations
  object :project_mutations do
    @desc "Create a new project"
    field :create_project, :project do
      arg :input, non_null(:project_input)
      resolve &RCTMSWeb.Resolvers.ProjectResolver.create_project/2
    end

    @desc "Update a project"
    field :update_project, :project do
      arg :id, non_null(:id)
      arg :input, non_null(:project_input)
      resolve &RCTMSWeb.Resolvers.ProjectResolver.update_project/2
    end

    @desc "Delete a project"
    field :delete_project, :project do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.ProjectResolver.delete_project/2
    end
  end

  # Project Subscriptions
  object :project_subscriptions do
    @desc "Subscribe to project updates"
    field :project_updated, :project do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger [:update_project], topic: fn
        %{id: id} -> [id]
        _ -> []
      end

      resolve fn project, _, _ ->
        {:ok, project}
      end
    end
  end
end
```

#### comment_resolver.ex
```elixir
defmodule RCTMSWeb.Resolvers.CommentResolver do
  alias RCTMS.Collaboration
  alias RCTMS.Tasks

  @doc """
  Get a comment by ID
  """
  def get_comment(%{id: id}, %{context: %{current_user: current_user}}) do
    comment = Collaboration.get_comment!(id)

    cond do
      # Anyone who can access the associated task can view the comment
      current_user_can_access_comment?(comment, current_user) ->
        {:ok, comment}

      true ->
        {:error, "Not authorized to access this comment"}
    end
  rescue
    Ecto.NoResultsError -> {:error, "Comment not found"}
  end

  def get_comment(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  List comments for a task
  """
  def list_task_comments(%{task_id: task_id}, %{context: %{current_user: current_user}}) do
    task = Tasks.get_task(task_id)

    cond do
      is_nil(task) ->
        {:error, "Task not found"}

      # Check if current user can access the task
      current_user_can_access_task?(task, current_user) ->
        comments = Collaboration.list_task_comments(task_id)
        {:ok, comments}

      true ->
        {:error, "Not authorized to access comments for this task"}
    end
  end

  def list_task_comments(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Create a new comment
  """
  def create_comment(%{input: comment_params}, %{context: %{current_user: current_user}}) do
    # Add user_id to comment params
    comment_params = Map.put(comment_params, :user_id, current_user.id)

    task = Tasks.get_task(comment_params.task_id)

    cond do
      is_nil(task) ->
        {:error, "Task not found"}

      # Anyone who can access the task can comment on it
      current_user_can_access_task?(task, current_user) ->
        case Collaboration.create_comment(comment_params) do
          {:ok, comment} ->
            # Publish the comment creation event for subscriptions
            Absinthe.Subscription.publish(
              RCTMSWeb.Endpoint,
              comment,
              comment_added: comment.task_id
            )
            {:ok, comment}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end

      true ->
        {:error, "Not authorized to comment on this task"}
    end
  end

  def create_comment(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Update a comment
  """
  def update_comment(%{id: id, content: content}, %{context: %{current_user: current_user}}) do
    comment = Collaboration.get_comment!(id)

    cond do
      # Only the author can update their comment
      comment.user_id != current_user.id ->
        {:error, "Not authorized to update this comment"}

      true ->
        case Collaboration.update_comment(comment, %{content: content}) do
          {:ok, updated_comment} ->
            {:ok, updated_comment}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  rescue
    Ecto.NoResultsError -> {:error, "Comment not found"}
  end

  def update_comment(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Delete a comment
  """
  def delete_comment(%{id: id}, %{context: %{current_user: current_user}}) do
    comment = Collaboration.get_comment!(id)

    cond do
      # Only the author can delete their comment
      comment.user_id != current_user.id ->
        {:error, "Not authorized to delete this comment"}

      true ->
        case Collaboration.delete_comment(comment) do
          {:ok, deleted_comment} ->
            {:ok, deleted_comment}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  rescue
    Ecto.NoResultsError -> {:error, "Comment not found"}
  end

  def delete_comment(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  # Helper function to check if current user can access a task
  defp current_user_can_access_task?(task, user) do
    task.creator_id == user.id ||
    task.assignee_id == user.id ||
    task_belongs_to_user_project?(task, user)
  end

  # Helper function to check if current user can access a comment
  defp current_user_can_access_comment?(comment, user) do
    task = Tasks.get_task(comment.task_id)
    !is_nil(task) && current_user_can_access_task?(task, user)
  end

  # Helper function to check if task belongs to a project owned by the user
  defp task_belongs_to_user_project?(task, user) do
    project = RCTMS.Projects.get_project(task.project_id)
    !is_nil(project) && project.owner_id == user.id
  end

  # Helper function to extract error messages from changesets
  defp extract_error_msg(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join(", ")
  end
end
```

#### user_resolver.ex
```elixir
defmodule RCTMSWeb.Resolvers.UserResolver do
  alias RCTMS.Accounts
  alias RCTMS.Accounts.Guardian

  @doc """
  Get the current authenticated user
  """
  def me(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Get a user by ID
  """
  def get_user(%{id: id}, _resolution) do
    case Accounts.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  List all users
  """
  def list_users(_args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  @doc """
  Register a new user
  """
  def register(%{input: user_params}, _resolution) do
    with {:ok, user} <- Accounts.create_user(user_params),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do

      # Convert NaiveDateTime to DateTime for proper GraphQL serialization
      user = %{user |
        inserted_at: naive_to_utc(user.inserted_at),
        updated_at: naive_to_utc(user.updated_at)
      }

      {:ok, %{user: user, token: token}}
    else
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  # Helper to convert NaiveDateTime to UTC DateTime
defp naive_to_utc(naive_dt) do
  DateTime.from_naive!(naive_dt, "Etc/UTC")
end

@doc """
Authenticates a user with email and password.
Returns a token and user data on success, or an error message on failure.
"""
def login(%{input: %{email: email, password: password}}, _resolution) do
with {:ok, user} <- Accounts.authenticate_user(email, password),
      {:ok, token, _claims} <- Guardian.encode_and_sign(user) do

  # Match the same user transformation you do in register
  user = %{user |
    inserted_at: naive_to_utc(user.inserted_at),
    updated_at: naive_to_utc(user.updated_at)
  }

  {:ok, %{
    token: token,
    user: user
  }}
else
  {:error, :not_found} ->
    {:error, "Invalid email or password"}

  {:error, :invalid_password} ->
    {:error, "Invalid email or password"}

  {:error, %Ecto.Changeset{} = changeset} ->
    errors = format_changeset_errors(changeset)
    {:error, "Validation failed: #{errors}"}

  {:error, reason} when is_atom(reason) ->
    {:error, "Login failed: #{reason}"}

  {:error, reason} ->
    {:error, "Authentication failed: #{inspect(reason)}"}
end
end

  # Helper function to format changeset errors
  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {key, value} -> "#{key}: #{value}" end)
    |> Enum.join(", ")
  end
  @doc """
  Update a user
  """
  def update_user(%{id: id, input: user_params}, %{context: %{current_user: current_user}}) do
    # Only allow users to update their own profile
    if current_user.id == String.to_integer(id) do
      user = Accounts.get_user(id)

      case Accounts.update_user(user, user_params) do
        {:ok, updated_user} ->
          {:ok, updated_user}

        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    else
      {:error, "Not authorized"}
    end
  end

  def update_user(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  # Helper function to extract error messages from changesets
  defp extract_error_msg(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join(", ")
  end
end
```

#### task_resolver.ex
```elixir
defmodule RCTMSWeb.Resolvers.TaskResolver do
  alias RCTMS.Tasks
  alias RCTMS.Projects

  @doc """
  Get a task by ID
  """
  def get_task(%{id: id}, %{context: %{current_user: current_user}}) do
    task = Tasks.get_task(id)

    cond do
      is_nil(task) ->
        {:error, "Task not found"}

      # Check if current user is the creator, assignee, or project owner
      task.creator_id == current_user.id ||
      task.assignee_id == current_user.id ||
      task_belongs_to_user_project?(task, current_user) ->
        {:ok, task}

      true ->
        {:error, "Not authorized to access this task"}
    end
  end

  def get_task(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  List all tasks for a project
  """
  def list_project_tasks(%{project_id: project_id}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(project_id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id == current_user.id ->
        tasks = Tasks.list_project_tasks(project_id)
        {:ok, tasks}

      true ->
        {:error, "Not authorized to access tasks for this project"}
    end
  end

  def list_project_tasks(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  List tasks assigned to the current user
  """
  def list_my_tasks(_args, %{context: %{current_user: current_user}}) do
    tasks = Tasks.list_assigned_tasks(current_user.id)
    {:ok, tasks}
  end

  def list_my_tasks(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Create a new task
  """
  def create_task(%{input: task_params}, %{context: %{current_user: current_user}}) do
    # Add creator_id to task params
    task_params = Map.put(task_params, :creator_id, current_user.id)

    # Check if user is authorized to create a task in this project
    project = Projects.get_project(task_params.project_id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id != current_user.id ->
        {:error, "Not authorized to create tasks in this project"}

      true ->
        case Tasks.create_task(task_params) do
          {:ok, task} ->
            # Publish the task creation event for subscriptions
            Absinthe.Subscription.publish(RCTMSWeb.Endpoint, task, task_created: task.project_id)
            {:ok, task}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  def create_task(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Update a task
  """
  def update_task(%{id: id, input: task_params}, %{context: %{current_user: current_user}}) do
    task = Tasks.get_task(id)

    cond do
      is_nil(task) ->
        {:error, "Task not found"}

      # Check if current user is the creator, assignee, or project owner
      task.creator_id == current_user.id ||
      task.assignee_id == current_user.id ||
      task_belongs_to_user_project?(task, current_user) ->
        case Tasks.update_task(task, task_params) do
          {:ok, updated_task} ->
            # Publish the task update event for subscriptions
            Absinthe.Subscription.publish(RCTMSWeb.Endpoint, updated_task, task_updated: id)

            # If assignee changed, notify them
            if Map.has_key?(task_params, :assignee_id) &&
               task_params.assignee_id != task.assignee_id &&
               !is_nil(task_params.assignee_id) do
              Absinthe.Subscription.publish(
                RCTMSWeb.Endpoint,
                updated_task,
                task_assigned: task_params.assignee_id
              )
            end

            {:ok, updated_task}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end

      true ->
        {:error, "Not authorized to update this task"}
    end
  end

  def update_task(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Delete a task
  """
  def delete_task(%{id: id}, %{context: %{current_user: current_user}}) do
    task = Tasks.get_task(id)

    cond do
      is_nil(task) ->
        {:error, "Task not found"}

      # Only creators or project owners can delete tasks
      task.creator_id == current_user.id ||
      task_belongs_to_user_project?(task, current_user) ->
        case Tasks.delete_task(task) do
          {:ok, deleted_task} ->
            {:ok, deleted_task}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end

      true ->
        {:error, "Not authorized to delete this task"}
    end
  end

  def delete_task(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  # Helper function to check if task belongs to a project owned by the user
  defp task_belongs_to_user_project?(task, user) do
    project = Projects.get_project(task.project_id)
    !is_nil(project) && project.owner_id == user.id
  end

  # Helper function to extract error messages from changesets
  defp extract_error_msg(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join(", ")
  end
end
```

#### project_resolver.ex
```elixir
defmodule RCTMSWeb.Resolvers.ProjectResolver do
  alias RCTMS.Projects

  @doc """
  Get a project by ID
  """
  def get_project(%{id: id}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id == current_user.id ->
        {:ok, project}

      true ->
        # Here we could implement additional checking for project members
        # For now, only owners can access their projects
        {:error, "Not authorized to access this project"}
    end
  end

  def get_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  List all projects for the current user
  """
  def list_projects(_args, %{context: %{current_user: current_user}}) do
    projects = Projects.list_user_projects(current_user.id)
    {:ok, projects}
  end

  def list_projects(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Create a new project
  """
  def create_project(%{input: project_params}, %{context: %{current_user: current_user}}) do
    # Add owner_id to project parameters
    project_params = Map.put(project_params, :owner_id, current_user.id)

    case Projects.create_project(project_params) do
      {:ok, project} ->
        # Publish the event for subscriptions
        Absinthe.Subscription.publish(RCTMSWeb.Endpoint, project, project_created: current_user.id)
        {:ok, project}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def create_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Update a project
  """
  def update_project(%{id: id, input: project_params}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id != current_user.id ->
        {:error, "Not authorized to update this project"}

      true ->
        case Projects.update_project(project, project_params) do
          {:ok, updated_project} ->
            # Publish the event for subscriptions
            Absinthe.Subscription.publish(RCTMSWeb.Endpoint, updated_project, project_updated: id)
            {:ok, updated_project}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  def update_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Delete a project
  """
  def delete_project(%{id: id}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id != current_user.id ->
        {:error, "Not authorized to delete this project"}

      true ->
        case Projects.delete_project(project) do
          {:ok, deleted_project} ->
            {:ok, deleted_project}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  def delete_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  # Helper function to extract error messages from changesets
  defp extract_error_msg(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join(", ")
  end
end
```

#### schema.ex
```elixir
defmodule RCTMSWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom

  # Import type definitions
  import_types RCTMSWeb.Schema.Types.User
  import_types RCTMSWeb.Schema.Types.Project
  import_types RCTMSWeb.Schema.Types.Task
  import_types RCTMSWeb.Schema.Types.Comment

  # Root query object
  query do
    import_fields :user_queries
    import_fields :project_queries
    import_fields :task_queries
    import_fields :comment_queries
  end

  # Root mutation object
  mutation do
    import_fields :user_mutations
    import_fields :project_mutations
    import_fields :task_mutations
    import_fields :comment_mutations
  end

  # Root subscription object
  subscription do
    import_fields :project_subscriptions
    import_fields :task_subscriptions
    import_fields :comment_subscriptions
  end

  # Setup Dataloader
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(RCTMS.Accounts, RCTMS.Accounts.data())
      |> Dataloader.add_source(RCTMS.Projects, RCTMS.Projects.data())
      |> Dataloader.add_source(RCTMS.Tasks, RCTMS.Tasks.data())
      |> Dataloader.add_source(RCTMS.Collaboration, RCTMS.Collaboration.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
```

#### context.ex
```elixir
defmodule RCTMSWeb.Schema.Context do
  @behaviour Plug

  import Plug.Conn
  alias RCTMS.Accounts.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
```

## Controllers
### user_controller.ex
```elixir
# lib/rctms_web/controllers/user_controller.ex
defmodule RCTMSWeb.UserController do
  use RCTMSWeb, :controller

  alias RCTMS.Accounts
  alias RCTMS.Accounts.User
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:user, user: user, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render(:user, user: user, token: token)
    end
  end
end
```

### project_controller.ex
```elixir
# lib/rctms_web/controllers/project_controller.ex
defmodule RCTMSWeb.ProjectController do
  use RCTMSWeb, :controller

  alias RCTMS.Projects
  alias RCTMS.Projects.Project
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def index(conn, _params) do
    # Get the current user from Guardian
    current_user = Guardian.Plug.current_resource(conn)
    projects = Projects.list_user_projects(current_user.id)
    render(conn, :index, projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    # Add the current user's ID as the owner_id
    current_user = Guardian.Plug.current_resource(conn)
    project_params = Map.put(project_params, "owner_id", current_user.id)

    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      project = RCTMS.Repo.preload(project, :owner)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project_with_details(id)
    render(conn, :show, project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the owner
    if project.owner_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to edit this project")
    else
      with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
        project = RCTMS.Repo.preload(project, :owner)
        render(conn, :show, project: project)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the owner
    if project.owner_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to delete this project")
    else
      with {:ok, %Project{}} <- Projects.delete_project(project) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
```

### task_controller.ex
```elixir
defmodule RCTMSWeb.TaskController do
  use RCTMSWeb, :controller

  alias RCTMS.Tasks
  alias RCTMS.Tasks.Task
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def index(conn, %{"project_id" => project_id}) do
    tasks = Tasks.list_project_tasks(project_id)
    render(conn, :index, tasks: tasks)
  end

  def index(conn, _params) do
    # Get the current user from Guardian
    current_user = Guardian.Plug.current_resource(conn)
    tasks = Tasks.list_assigned_tasks(current_user.id)
    render(conn, :index, tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    # Add the current user's ID as the creator_id
    current_user = Guardian.Plug.current_resource(conn)
    task_params = Map.put(task_params, "creator_id", current_user.id)

    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      task = RCTMS.Repo.preload(task, [:assignee, :creator, :project])

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task_with_details(id)
    render(conn, :show, task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Check if the current user is the creator or the assignee
    if task.creator_id != current_user.id && task.assignee_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to edit this task")
    else
      with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
        task = RCTMS.Repo.preload(task, [:assignee, :creator, :project])
        render(conn, :show, task: task)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Check if the current user is the creator
    if task.creator_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to delete this task")
    else
      with {:ok, %Task{}} <- Tasks.delete_task(task) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
```

### fallback_controller.ex
```elixir
# lib/rctms_web/controllers/fallback_controller.ex
defmodule RCTMSWeb.FallbackController do
  use RCTMSWeb, :controller

  # Called for all Ecto.Changeset errors
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: RCTMSWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # Called when a resource is not found
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: RCTMSWeb.ErrorJSON)
    |> render(:"404")
  end

  # Called for unauthorized access
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: RCTMSWeb.ErrorJSON)
    |> render(:"401")
  end
end
```

### comment_controller.ex
```elixir
# lib/rctms_web/controllers/comment_controller.ex
defmodule RCTMSWeb.CommentController do
  use RCTMSWeb, :controller

  alias RCTMS.Collaboration
  alias RCTMS.Collaboration.Comment
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def index(conn, %{"task_id" => task_id}) do
    comments = Collaboration.list_task_comments(task_id)
    render(conn, :index, comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    # Add the current user's ID as the user_id
    current_user = Guardian.Plug.current_resource(conn)
    comment_params = Map.put(comment_params, "user_id", current_user.id)

    with {:ok, %Comment{} = comment} <- Collaboration.create_comment(comment_params) do
      comment = RCTMS.Repo.preload(comment, :user)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/comments/#{comment}")
      |> render(:show, comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Collaboration.get_comment!(id)
    render(conn, :show, comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Collaboration.get_comment!(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the author
    if comment.user_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to edit this comment")
    else
      with {:ok, %Comment{} = comment} <- Collaboration.update_comment(comment, comment_params) do
        render(conn, :show, comment: comment)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Collaboration.get_comment!(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the author
    if comment.user_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to delete this comment")
    else
      with {:ok, %Comment{}} <- Collaboration.delete_comment(comment) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
```

### page_controller.ex
```elixir
defmodule RCTMSWeb.PageController do
  use RCTMSWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
```

## Context Modules
### comment.ex
```elixir
defmodule RCTMS.Collaboration.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :task, RCTMS.Tasks.Task
    belongs_to :user, RCTMS.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :task_id, :user_id])
    |> validate_required([:content, :task_id, :user_id])
    |> foreign_key_constraint(:task_id)
    |> foreign_key_constraint(:user_id)
  end
end
```

### task.ex
```elixir
defmodule RCTMS.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string, default: "pending" # pending, in_progress, completed
    field :priority, :string, default: "medium" # low, medium, high
    field :due_date, :utc_datetime

    belongs_to :project, RCTMS.Projects.Project
    belongs_to :assignee, RCTMS.Accounts.User
    belongs_to :creator, RCTMS.Accounts.User
    has_many :comments, RCTMS.Collaboration.Comment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :priority, :due_date, :project_id, :assignee_id, :creator_id])
    |> validate_required([:title, :status, :priority, :project_id, :creator_id])
    |> validate_inclusion(:status, ["pending", "in_progress", "completed"])
    |> validate_inclusion(:priority, ["low", "medium", "high"])
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:assignee_id)
    |> foreign_key_constraint(:creator_id)
  end
end
```

### project.ex
```elixir
defmodule RCTMS.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string

    belongs_to :owner, RCTMS.Accounts.User
    has_many :tasks, RCTMS.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :owner_id])
    |> validate_required([:name, :owner_id])
    |> validate_length(:name, min: 3, max: 100)
    |> foreign_key_constraint(:owner_id)
  end
end
```

### tasks.ex
```elixir
defmodule RCTMS.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias RCTMS.Repo
  alias RCTMS.Tasks.Task

  @doc """
  Returns the list of tasks.
  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.
  """
  def get_task(id), do: Repo.get(Task, id)

  @doc """
  Gets a single task with associations.
  """
  def get_task_with_details(id) do
    Task
    |> Repo.get(id)
    |> Repo.preload([:project, :assignee, :creator, :comments])
  end

  @doc """
  Creates a task.
  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.
  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.
  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns tasks for a project.
  """
  def list_project_tasks(project_id) do
    Task
    |> where([t], t.project_id == ^project_id)
    |> Repo.all()
  end

  @doc """
  Returns tasks assigned to a user.
  """
  def list_assigned_tasks(user_id) do
    Task
    |> where([t], t.assignee_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Returns tasks created by a user.
  """
  def list_created_tasks(user_id) do
    Task
    |> where([t], t.creator_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Returns a dataloader source for Tasks data.
  This enables efficient loading of associations.
  """
  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @doc """
  Custom query function for dataloader to support filtering.
  """
  def query(queryable, %{assignee_id: assignee_id}) when not is_nil(assignee_id) do
    where(queryable, [t], t.assignee_id == ^assignee_id)
  end

  def query(queryable, %{creator_id: creator_id}) when not is_nil(creator_id) do
    where(queryable, [t], t.creator_id == ^creator_id)
  end

  def query(queryable, %{project_id: project_id}) when not is_nil(project_id) do
    where(queryable, [t], t.project_id == ^project_id)
  end

  def query(queryable, _params) do
    queryable
  end
end
```

### accounts.ex
```elixir
defmodule RCTMS.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RCTMS.Repo
  alias RCTMS.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a user by email.
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by username.
  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Authenticates a user.
  """
  def authenticate_user(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        # Prevent timing attacks
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end

  @doc """
  Returns a dataloader source for Accounts data.
  This enables efficient loading of associations.
  """
  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @doc """
  Custom query function for dataloader to support filtering.
  """
  def query(queryable, _params) do
    queryable
  end
end
```

### projects.ex
```elixir
defmodule RCTMS.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias RCTMS.Repo
  alias RCTMS.Projects.Project

  @doc """
  Returns the list of projects.
  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.
  """
  def get_project(id), do: Repo.get(Project, id)

  @doc """
  Gets a single project with preloaded associations.
  """
  def get_project_with_details(id) do
    Project
    |> Repo.get(id)
    |> Repo.preload([:owner, tasks: [:assignee, :creator]])
  end

  @doc """
  Get projects owned by a user.
  """
  def list_user_projects(user_id) do
    Project
    |> where([p], p.owner_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a project.
  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.
  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.
  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns a dataloader source for Projects data.
  This enables efficient loading of associations.
  """
  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @doc """
  Custom query function for dataloader to support filtering.
  """
  def query(queryable, _params) do
    queryable
  end
end
```

### user.ex
```elixir
defmodule RCTMS.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :owned_projects, RCTMS.Projects.Project, foreign_key: :owner_id
    has_many :assigned_tasks, RCTMS.Tasks.Task, foreign_key: :assignee_id
    has_many :created_tasks, RCTMS.Tasks.Task, foreign_key: :creator_id
    has_many :comments, RCTMS.Collaboration.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> validate_length(:username, min: 3, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # We'll use Bcrypt for password hashing
    # We'll need to add the :bcrypt_elixir dependency
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
```

### error_handler.ex
```elixir
# lib/rctms/accounts/error_handler.ex
defmodule RCTMS.Accounts.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
```

### guardian.ex
```elixir
# lib/rctms/accounts/guardian.ex
defmodule RCTMS.Accounts.Guardian do
  use Guardian, otp_app: :rctms

  alias RCTMS.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
```

### collaboration.ex
```elixir
defmodule RCTMS.Collaboration do
  @moduledoc """
  The Collaboration context.
  """

  import Ecto.Query, warn: false
  alias RCTMS.Repo
  alias RCTMS.Collaboration.Comment

  @doc """
  Returns the list of comments.
  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Returns comments for a specific task.
  """
  def list_task_comments(task_id) do
    Comment
    |> where([c], c.task_id == ^task_id)
    |> order_by([c], asc: c.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single comment.
  """
  def get_comment!(id), do: Repo.get!(Comment, id) |> Repo.preload(:user)

  @doc """
  Creates a comment.
  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.
  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.
  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns a dataloader source for Collaboration data.
  This enables efficient loading of associations.
  """
  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @doc """
  Custom query function for dataloader to support filtering.
  """
  def query(Comment = queryable, %{task_id: task_id}) when not is_nil(task_id) do
    where(queryable, [c], c.task_id == ^task_id)
    |> order_by([c], asc: c.inserted_at)
  end

  def query(Comment = queryable, %{user_id: user_id}) when not is_nil(user_id) do
    where(queryable, [c], c.user_id == ^user_id)
  end

  def query(queryable, _params) do
    queryable
  end
end
```

## LiveView Components
No LiveView files found.

### LiveView Templates
#### root.html.heex
```heex
<!DOCTYPE html>
<html lang="en" class="[scrollbar-gutter:stable]">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={get_csrf_token()} />
    <.live_title default="RCTMS" suffix=" · Phoenix Framework">
      {assigns[:page_title]}
    </.live_title>
    <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
    </script>
  </head>
  <body class="bg-white">
    {@inner_content}
  </body>
</html>
```

#### app.html.heex
```heex
<header class="px-4 sm:px-6 lg:px-8">
  <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
    <div class="flex items-center gap-4">
      <a href="/">
        <img src={~p"/images/logo.svg"} width="36" />
      </a>
      <p class="bg-brand/5 text-brand rounded-full px-2 font-medium leading-6">
        v{Application.spec(:phoenix, :vsn)}
      </p>
    </div>
    <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">
      <a href="https://twitter.com/elixirphoenix" class="hover:text-zinc-700">
        @elixirphoenix
      </a>
      <a href="https://github.com/phoenixframework/phoenix" class="hover:text-zinc-700">
        GitHub
      </a>
      <a
        href="https://hexdocs.pm/phoenix/overview.html"
        class="rounded-lg bg-zinc-100 px-2 py-1 hover:bg-zinc-200/80"
      >
        Get Started <span aria-hidden="true">&rarr;</span>
      </a>
    </div>
  </div>
</header>
<main class="px-4 py-20 sm:px-6 lg:px-8">
  <div class="mx-auto max-w-2xl">
    <.flash_group flash={@flash} />
    {@inner_content}
  </div>
</main>
```

#### home.html.heex
```heex
<.flash_group flash={@flash} />
<div class="left-[40rem] fixed inset-y-0 right-0 z-0 hidden lg:block xl:left-[50rem]">
  <svg
    viewBox="0 0 1480 957"
    fill="none"
    aria-hidden="true"
    class="absolute inset-0 h-full w-full"
    preserveAspectRatio="xMinYMid slice"
  >
    <path fill="#EE7868" d="M0 0h1480v957H0z" />
    <path
      d="M137.542 466.27c-582.851-48.41-988.806-82.127-1608.412 658.2l67.39 810 3083.15-256.51L1535.94-49.622l-98.36 8.183C1269.29 281.468 734.115 515.799 146.47 467.012l-8.928-.742Z"
      fill="#FF9F92"
    />
    <path
      d="M371.028 528.664C-169.369 304.988-545.754 149.198-1361.45 665.565l-182.58 792.025 3014.73 694.98 389.42-1689.25-96.18-22.171C1505.28 697.438 924.153 757.586 379.305 532.09l-8.277-3.426Z"
      fill="#FA8372"
    />
    <path
      d="M359.326 571.714C-104.765 215.795-428.003-32.102-1349.55 255.554l-282.3 1224.596 3047.04 722.01 312.24-1354.467C1411.25 1028.3 834.355 935.995 366.435 577.166l-7.109-5.452Z"
      fill="#E96856"
      fill-opacity=".6"
    />
    <path
      d="M1593.87 1236.88c-352.15 92.63-885.498-145.85-1244.602-613.557l-5.455-7.105C-12.347 152.31-260.41-170.8-1225-131.458l-368.63 1599.048 3057.19 704.76 130.31-935.47Z"
      fill="#C42652"
      fill-opacity=".2"
    />
    <path
      d="M1411.91 1526.93c-363.79 15.71-834.312-330.6-1085.883-863.909l-3.822-8.102C72.704 125.95-101.074-242.476-1052.01-408.907l-699.85 1484.267 2837.75 1338.01 326.02-886.44Z"
      fill="#A41C42"
      fill-opacity=".2"
    />
    <path
      d="M1116.26 1863.69c-355.457-78.98-720.318-535.27-825.287-1115.521l-1.594-8.816C185.286 163.833 112.786-237.016-762.678-643.898L-1822.83 608.665 571.922 2635.55l544.338-771.86Z"
      fill="#A41C42"
      fill-opacity=".2"
    />
  </svg>
</div>
<div class="px-4 py-10 sm:px-6 sm:py-28 lg:px-8 xl:px-28 xl:py-32">
  <div class="mx-auto max-w-xl lg:mx-0">
    <svg viewBox="0 0 71 48" class="h-12" aria-hidden="true">
      <path
        d="m26.371 33.477-.552-.1c-3.92-.729-6.397-3.1-7.57-6.829-.733-2.324.597-4.035 3.035-4.148 1.995-.092 3.362 1.055 4.57 2.39 1.557 1.72 2.984 3.558 4.514 5.305 2.202 2.515 4.797 4.134 8.347 3.634 3.183-.448 5.958-1.725 8.371-3.828.363-.316.761-.592 1.144-.886l-.241-.284c-2.027.63-4.093.841-6.205.735-3.195-.16-6.24-.828-8.964-2.582-2.486-1.601-4.319-3.746-5.19-6.611-.704-2.315.736-3.934 3.135-3.6.948.133 1.746.56 2.463 1.165.583.493 1.143 1.015 1.738 1.493 2.8 2.25 6.712 2.375 10.265-.068-5.842-.026-9.817-3.24-13.308-7.313-1.366-1.594-2.7-3.216-4.095-4.785-2.698-3.036-5.692-5.71-9.79-6.623C12.8-.623 7.745.14 2.893 2.361 1.926 2.804.997 3.319 0 4.149c.494 0 .763.006 1.032 0 2.446-.064 4.28 1.023 5.602 3.024.962 1.457 1.415 3.104 1.761 4.798.513 2.515.247 5.078.544 7.605.761 6.494 4.08 11.026 10.26 13.346 2.267.852 4.591 1.135 7.172.555ZM10.751 3.852c-.976.246-1.756-.148-2.56-.962 1.377-.343 2.592-.476 3.897-.528-.107.848-.607 1.306-1.336 1.49Zm32.002 37.924c-.085-.626-.62-.901-1.04-1.228-1.857-1.446-4.03-1.958-6.333-2-1.375-.026-2.735-.128-4.031-.61-.595-.22-1.26-.505-1.244-1.272.015-.78.693-1 1.31-1.184.505-.15 1.026-.247 1.6-.382-1.46-.936-2.886-1.065-4.787-.3-2.993 1.202-5.943 1.06-8.926-.017-1.684-.608-3.179-1.563-4.735-2.408l-.043.03a2.96 2.96 0 0 0 .04-.029c-.038-.117-.107-.12-.197-.054l.122.107c1.29 2.115 3.034 3.817 5.004 5.271 3.793 2.8 7.936 4.471 12.784 3.73A66.714 66.714 0 0 1 37 40.877c1.98-.16 3.866.398 5.753.899Zm-9.14-30.345c-.105-.076-.206-.266-.42-.069 1.745 2.36 3.985 4.098 6.683 5.193 4.354 1.767 8.773 2.07 13.293.51 3.51-1.21 6.033-.028 7.343 3.38.19-3.955-2.137-6.837-5.843-7.401-2.084-.318-4.01.373-5.962.94-5.434 1.575-10.485.798-15.094-2.553Zm27.085 15.425c.708.059 1.416.123 2.124.185-1.6-1.405-3.55-1.517-5.523-1.404-3.003.17-5.167 1.903-7.14 3.972-1.739 1.824-3.31 3.87-5.903 4.604.043.078.054.117.066.117.35.005.699.021 1.047.005 3.768-.17 7.317-.965 10.14-3.7.89-.86 1.685-1.817 2.544-2.71.716-.746 1.584-1.159 2.645-1.07Zm-8.753-4.67c-2.812.246-5.254 1.409-7.548 2.943-1.766 1.18-3.654 1.738-5.776 1.37-.374-.066-.75-.114-1.124-.17l-.013.156c.135.07.265.151.405.207.354.14.702.308 1.07.395 4.083.971 7.992.474 11.516-1.803 2.221-1.435 4.521-1.707 7.013-1.336.252.038.503.083.756.107.234.022.479.255.795.003-2.179-1.574-4.526-2.096-7.094-1.872Zm-10.049-9.544c1.475.051 2.943-.142 4.486-1.059-.452.04-.643.04-.827.076-2.126.424-4.033-.04-5.733-1.383-.623-.493-1.257-.974-1.889-1.457-2.503-1.914-5.374-2.555-8.514-2.5.05.154.054.26.108.315 3.417 3.455 7.371 5.836 12.369 6.008Zm24.727 17.731c-2.114-2.097-4.952-2.367-7.578-.537 1.738.078 3.043.632 4.101 1.728.374.388.763.768 1.182 1.106 1.6 1.29 4.311 1.352 5.896.155-1.861-.726-1.861-.726-3.601-2.452Zm-21.058 16.06c-1.858-3.46-4.981-4.24-8.59-4.008a9.667 9.667 0 0 1 2.977 1.39c.84.586 1.547 1.311 2.243 2.055 1.38 1.473 3.534 2.376 4.962 2.07-.656-.412-1.238-.848-1.592-1.507Zm17.29-19.32c0-.023.001-.045.003-.068l-.006.006.006-.006-.036-.004.021.018.012.053Zm-20 14.744a7.61 7.61 0 0 0-.072-.041.127.127 0 0 0 .015.043c.005.008.038 0 .058-.002Zm-.072-.041-.008-.034-.008.01.008-.01-.022-.006.005.026.024.014Z"
        fill="#FD4F00"
      />
    </svg>
    <h1 class="text-brand mt-10 flex items-center text-sm font-semibold leading-6">
      Phoenix Framework
      <small class="bg-brand/5 text-[0.8125rem] ml-3 rounded-full px-2 font-medium leading-6">
        v{Application.spec(:phoenix, :vsn)}
      </small>
    </h1>
    <p class="text-[2rem] mt-4 font-semibold leading-10 tracking-tighter text-zinc-900 text-balance">
      Peace of mind from prototype to production.
    </p>
    <p class="mt-4 text-base leading-7 text-zinc-600">
      Build rich, interactive web applications quickly, with less code and fewer moving parts. Join our growing community of developers using Phoenix to craft APIs, HTML5 apps and more, for fun or at scale.
    </p>
    <div class="flex">
      <div class="w-full sm:w-auto">
        <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-4 sm:grid-cols-3">
          <a
            href="https://hexdocs.pm/phoenix/overview.html"
            class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
          >
            <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
            </span>
            <span class="relative flex items-center gap-4 sm:flex-col">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true" class="h-6 w-6">
                <path d="m12 4 10-2v18l-10 2V4Z" fill="#18181B" fill-opacity=".15" />
                <path
                  d="M12 4 2 2v18l10 2m0-18v18m0-18 10-2v18l-10 2"
                  stroke="#18181B"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              Guides &amp; Docs
            </span>
          </a>
          <a
            href="https://github.com/phoenixframework/phoenix"
            class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
          >
            <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
            </span>
            <span class="relative flex items-center gap-4 sm:flex-col">
              <svg viewBox="0 0 24 24" aria-hidden="true" class="h-6 w-6">
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M12 0C5.37 0 0 5.506 0 12.303c0 5.445 3.435 10.043 8.205 11.674.6.107.825-.262.825-.585 0-.292-.015-1.261-.015-2.291C6 21.67 5.22 20.346 4.98 19.654c-.135-.354-.72-1.446-1.23-1.738-.42-.23-1.02-.8-.015-.815.945-.015 1.62.892 1.845 1.261 1.08 1.86 2.805 1.338 3.495 1.015.105-.8.42-1.338.765-1.645-2.67-.308-5.46-1.37-5.46-6.075 0-1.338.465-2.446 1.23-3.307-.12-.308-.54-1.569.12-3.26 0 0 1.005-.323 3.3 1.26.96-.276 1.98-.415 3-.415s2.04.139 3 .416c2.295-1.6 3.3-1.261 3.3-1.261.66 1.691.24 2.952.12 3.26.765.861 1.23 1.953 1.23 3.307 0 4.721-2.805 5.767-5.475 6.075.435.384.81 1.122.81 2.276 0 1.645-.015 2.968-.015 3.383 0 .323.225.707.825.585a12.047 12.047 0 0 0 5.919-4.489A12.536 12.536 0 0 0 24 12.304C24 5.505 18.63 0 12 0Z"
                  fill="#18181B"
                />
              </svg>
              Source Code
            </span>
          </a>
          <a
            href={"https://github.com/phoenixframework/phoenix/blob/v#{Application.spec(:phoenix, :vsn)}/CHANGELOG.md"}
            class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
          >
            <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
            </span>
            <span class="relative flex items-center gap-4 sm:flex-col">
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true" class="h-6 w-6">
                <path
                  d="M12 1v6M12 17v6"
                  stroke="#18181B"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
                <circle
                  cx="12"
                  cy="12"
                  r="4"
                  fill="#18181B"
                  fill-opacity=".15"
                  stroke="#18181B"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              Changelog
            </span>
          </a>
        </div>
        <div class="mt-10 grid grid-cols-1 gap-y-4 text-sm leading-6 text-zinc-700 sm:grid-cols-2">
          <div>
            <a
              href="https://twitter.com/elixirphoenix"
              class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
            >
              <svg
                viewBox="0 0 16 16"
                aria-hidden="true"
                class="h-4 w-4 fill-zinc-400 group-hover:fill-zinc-600"
              >
                <path d="M5.403 14c5.283 0 8.172-4.617 8.172-8.62 0-.131 0-.262-.008-.391A6.033 6.033 0 0 0 15 3.419a5.503 5.503 0 0 1-1.65.477 3.018 3.018 0 0 0 1.263-1.676 5.579 5.579 0 0 1-1.824.736 2.832 2.832 0 0 0-1.63-.916 2.746 2.746 0 0 0-1.821.319A2.973 2.973 0 0 0 8.076 3.78a3.185 3.185 0 0 0-.182 1.938 7.826 7.826 0 0 1-3.279-.918 8.253 8.253 0 0 1-2.64-2.247 3.176 3.176 0 0 0-.315 2.208 3.037 3.037 0 0 0 1.203 1.836A2.739 2.739 0 0 1 1.56 6.22v.038c0 .7.23 1.377.65 1.919.42.54 1.004.912 1.654 1.05-.423.122-.866.14-1.297.052.184.602.541 1.129 1.022 1.506a2.78 2.78 0 0 0 1.662.598 5.656 5.656 0 0 1-2.007 1.074A5.475 5.475 0 0 1 1 12.64a7.827 7.827 0 0 0 4.403 1.358" />
              </svg>
              Follow on Twitter
            </a>
          </div>
          <div>
            <a
              href="https://elixirforum.com"
              class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
            >
              <svg
                viewBox="0 0 16 16"
                aria-hidden="true"
                class="h-4 w-4 fill-zinc-400 group-hover:fill-zinc-600"
              >
                <path d="M8 13.833c3.866 0 7-2.873 7-6.416C15 3.873 11.866 1 8 1S1 3.873 1 7.417c0 1.081.292 2.1.808 2.995.606 1.05.806 2.399.086 3.375l-.208.283c-.285.386-.01.905.465.85.852-.098 2.048-.318 3.137-.81a3.717 3.717 0 0 1 1.91-.318c.263.027.53.041.802.041Z" />
              </svg>
              Discuss on the Elixir Forum
            </a>
          </div>
          <div>
            <a
              href="https://web.libera.chat/#elixir"
              class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
            >
              <svg
                viewBox="0 0 16 16"
                aria-hidden="true"
                class="h-4 w-4 fill-zinc-400 group-hover:fill-zinc-600"
              >
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M6.356 2.007a.75.75 0 0 1 .637.849l-1.5 10.5a.75.75 0 1 1-1.485-.212l1.5-10.5a.75.75 0 0 1 .848-.637ZM11.356 2.008a.75.75 0 0 1 .637.848l-1.5 10.5a.75.75 0 0 1-1.485-.212l1.5-10.5a.75.75 0 0 1 .848-.636Z"
                />
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M14 5.25a.75.75 0 0 1-.75.75h-9.5a.75.75 0 0 1 0-1.5h9.5a.75.75 0 0 1 .75.75ZM13 10.75a.75.75 0 0 1-.75.75h-9.5a.75.75 0 0 1 0-1.5h9.5a.75.75 0 0 1 .75.75Z"
                />
              </svg>
              Chat on Libera IRC
            </a>
          </div>
          <div>
            <a
              href="https://discord.gg/elixir"
              class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
            >
              <svg
                viewBox="0 0 16 16"
                aria-hidden="true"
                class="h-4 w-4 fill-zinc-400 group-hover:fill-zinc-600"
              >
                <path d="M13.545 2.995c-1.02-.46-2.114-.8-3.257-.994a.05.05 0 0 0-.052.024c-.141.246-.297.567-.406.82a12.377 12.377 0 0 0-3.658 0 8.238 8.238 0 0 0-.412-.82.052.052 0 0 0-.052-.024 13.315 13.315 0 0 0-3.257.994.046.046 0 0 0-.021.018C.356 6.063-.213 9.036.066 11.973c.001.015.01.029.02.038a13.353 13.353 0 0 0 3.996 1.987.052.052 0 0 0 .056-.018c.308-.414.582-.85.818-1.309a.05.05 0 0 0-.028-.069 8.808 8.808 0 0 1-1.248-.585.05.05 0 0 1-.005-.084c.084-.062.168-.126.248-.191a.05.05 0 0 1 .051-.007c2.619 1.176 5.454 1.176 8.041 0a.05.05 0 0 1 .053.006c.08.065.164.13.248.192a.05.05 0 0 1-.004.084c-.399.23-.813.423-1.249.585a.05.05 0 0 0-.027.07c.24.457.514.893.817 1.307a.051.051 0 0 0 .056.019 13.31 13.31 0 0 0 4.001-1.987.05.05 0 0 0 .021-.037c.334-3.396-.559-6.345-2.365-8.96a.04.04 0 0 0-.021-.02Zm-8.198 7.19c-.789 0-1.438-.712-1.438-1.587 0-.874.637-1.586 1.438-1.586.807 0 1.45.718 1.438 1.586 0 .875-.637 1.587-1.438 1.587Zm5.316 0c-.788 0-1.438-.712-1.438-1.587 0-.874.637-1.586 1.438-1.586.807 0 1.45.718 1.438 1.586 0 .875-.63 1.587-1.438 1.587Z" />
              </svg>
              Join our Discord server
            </a>
          </div>
          <div>
            <a
              href="https://fly.io/docs/elixir/getting-started/"
              class="group -mx-2 -my-0.5 inline-flex items-center gap-3 rounded-lg px-2 py-0.5 hover:bg-zinc-50 hover:text-zinc-900"
            >
              <svg
                viewBox="0 0 20 20"
                aria-hidden="true"
                class="h-4 w-4 fill-zinc-400 group-hover:fill-zinc-600"
              >
                <path d="M1 12.5A4.5 4.5 0 005.5 17H15a4 4 0 001.866-7.539 3.504 3.504 0 00-4.504-4.272A4.5 4.5 0 004.06 8.235 4.502 4.502 0 001 12.5z" />
              </svg>
              Deploy your application
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

## GraphQL Schema
### schema.ex
```elixir
defmodule RCTMSWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom

  # Import type definitions
  import_types RCTMSWeb.Schema.Types.User
  import_types RCTMSWeb.Schema.Types.Project
  import_types RCTMSWeb.Schema.Types.Task
  import_types RCTMSWeb.Schema.Types.Comment

  # Root query object
  query do
    import_fields :user_queries
    import_fields :project_queries
    import_fields :task_queries
    import_fields :comment_queries
  end

  # Root mutation object
  mutation do
    import_fields :user_mutations
    import_fields :project_mutations
    import_fields :task_mutations
    import_fields :comment_mutations
  end

  # Root subscription object
  subscription do
    import_fields :project_subscriptions
    import_fields :task_subscriptions
    import_fields :comment_subscriptions
  end

  # Setup Dataloader
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(RCTMS.Accounts, RCTMS.Accounts.data())
      |> Dataloader.add_source(RCTMS.Projects, RCTMS.Projects.data())
      |> Dataloader.add_source(RCTMS.Tasks, RCTMS.Tasks.data())
      |> Dataloader.add_source(RCTMS.Collaboration, RCTMS.Collaboration.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
```

## Channels
### project_channel.ex
```elixir
# lib/rctms_web/channels/project_channel.ex
defmodule RCTMSWeb.ProjectChannel do
  use Phoenix.Channel
  alias RCTMS.Projects
  alias RCTMS.Tasks

  def join("project:" <> project_id, _params, socket) do
    project_id = String.to_integer(project_id)

    case Projects.get_project(project_id) do
      nil ->
        {:error, %{reason: "Project not found"}}
      project ->
        if project.owner_id == socket.assigns.current_user_id do
          project = Projects.get_project_with_details(project_id)
          {:ok, %{project: project}, assign(socket, :project_id, project_id)}
        else
          # Here you would check if the user is a member of the project
          {:error, %{reason: "Unauthorized"}}
        end
    end
  end

  def handle_in("new_task", params, socket) do
    project_id = socket.assigns.project_id
    user_id = socket.assigns.current_user_id

    task_params = Map.merge(params, %{
      "project_id" => project_id,
      "creator_id" => user_id
    })

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        task = task |> RCTMS.Repo.preload([:assignee, :creator])
        broadcast!(socket, "task_created", %{task: task})
        {:reply, {:ok, %{task: task}}, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: format_errors(changeset)}}, socket}
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
```

## GenServers and Supervisors
### telemetry.ex
```elixir
defmodule RCTMSWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.start.system_time",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.start.system_time",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.exception.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.socket_connected.duration",
        unit: {:native, :millisecond}
      ),
      sum("phoenix.socket_drain.count"),
      summary("phoenix.channel_joined.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("rctms.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("rctms.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("rctms.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("rctms.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("rctms.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {RCTMSWeb, :count_users, []}
    ]
  end
end
```

## Tests
### error_html_test.exs
```elixir
defmodule RCTMSWeb.ErrorHTMLTest do
  use RCTMSWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(RCTMSWeb.ErrorHTML, "404", "html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(RCTMSWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
```

### page_controller_test.exs
```elixir
defmodule RCTMSWeb.PageControllerTest do
  use RCTMSWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
```

### error_json_test.exs
```elixir
defmodule RCTMSWeb.ErrorJSONTest do
  use RCTMSWeb.ConnCase, async: true

  test "renders 404" do
    assert RCTMSWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert RCTMSWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
```

Note: Only showing first 5 test files. There may be more.

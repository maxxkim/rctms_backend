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
    |> Map.put(:pubsub, RCTMS.PubSub)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end

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

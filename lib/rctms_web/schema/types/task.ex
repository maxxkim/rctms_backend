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

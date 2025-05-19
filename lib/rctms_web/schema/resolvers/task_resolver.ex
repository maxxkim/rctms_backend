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

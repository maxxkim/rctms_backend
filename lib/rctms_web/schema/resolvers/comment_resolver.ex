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

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

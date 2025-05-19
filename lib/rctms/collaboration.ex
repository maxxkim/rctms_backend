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

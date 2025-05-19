# lib/rctms_web/controllers/comment_json.ex
defmodule RCTMSWeb.CommentJSON do
  @doc """
  Renders a list of comments.
  """
  def index(%{comments: comments}) do
    %{data: for(comment <- comments, do: data(comment))}
  end

  @doc """
  Renders a single comment.
  """
  def show(%{comment: comment}) do
    %{data: data(comment)}
  end

  defp data(%{user: user} = comment) when not is_nil(user) do
    %{
      id: comment.id,
      content: comment.content,
      task_id: comment.task_id,
      user: %{
        id: user.id,
        username: user.username
      },
      inserted_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end

  defp data(comment) do
    %{
      id: comment.id,
      content: comment.content,
      task_id: comment.task_id,
      user_id: comment.user_id,
      inserted_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end
end

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

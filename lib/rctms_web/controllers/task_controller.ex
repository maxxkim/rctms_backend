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

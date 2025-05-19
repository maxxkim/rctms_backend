# lib/rctms_web/controllers/project_controller.ex
defmodule RCTMSWeb.ProjectController do
  use RCTMSWeb, :controller

  alias RCTMS.Projects
  alias RCTMS.Projects.Project
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def index(conn, _params) do
    # Get the current user from Guardian
    current_user = Guardian.Plug.current_resource(conn)
    projects = Projects.list_user_projects(current_user.id)
    render(conn, :index, projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    # Add the current user's ID as the owner_id
    current_user = Guardian.Plug.current_resource(conn)
    project_params = Map.put(project_params, "owner_id", current_user.id)

    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      project = RCTMS.Repo.preload(project, :owner)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project_with_details(id)
    render(conn, :show, project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the owner
    if project.owner_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to edit this project")
    else
      with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
        project = RCTMS.Repo.preload(project, :owner)
        render(conn, :show, project: project)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    current_user = Guardian.Plug.current_resource(conn)

    # Verify that the current user is the owner
    if project.owner_id != current_user.id do
      conn
      |> put_status(:forbidden)
      |> put_view(json: RCTMSWeb.ErrorJSON)
      |> render(:"403", message: "You don't have permission to delete this project")
    else
      with {:ok, %Project{}} <- Projects.delete_project(project) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end

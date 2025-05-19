# lib/rctms_web/channels/project_channel.ex
defmodule RCTMSWeb.ProjectChannel do
  use Phoenix.Channel
  alias RCTMS.Projects
  alias RCTMS.Tasks

  def join("project:" <> project_id, _params, socket) do
    project_id = String.to_integer(project_id)

    case Projects.get_project(project_id) do
      nil ->
        {:error, %{reason: "Project not found"}}
      project ->
        if project.owner_id == socket.assigns.current_user_id do
          project = Projects.get_project_with_details(project_id)
          {:ok, %{project: project}, assign(socket, :project_id, project_id)}
        else
          # Here you would check if the user is a member of the project
          {:error, %{reason: "Unauthorized"}}
        end
    end
  end

  def handle_in("new_task", params, socket) do
    project_id = socket.assigns.project_id
    user_id = socket.assigns.current_user_id

    task_params = Map.merge(params, %{
      "project_id" => project_id,
      "creator_id" => user_id
    })

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        task = task |> RCTMS.Repo.preload([:assignee, :creator])
        broadcast!(socket, "task_created", %{task: task})
        {:reply, {:ok, %{task: task}}, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: format_errors(changeset)}}, socket}
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end

# lib/rctms_web/controllers/project_json.ex
defmodule RCTMSWeb.ProjectJSON do
  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project)}
  end

  defp data(%{owner: owner, tasks: tasks} = project) when not is_nil(owner) and is_list(tasks) do
    %{
      id: project.id,
      name: project.name,
      description: project.description,
      owner: %{
        id: owner.id,
        username: owner.username
      },
      tasks: for(task <- tasks, do: %{
        id: task.id,
        title: task.title,
        status: task.status,
        priority: task.priority
      }),
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end

  defp data(%{owner: owner} = project) when not is_nil(owner) do
    %{
      id: project.id,
      name: project.name,
      description: project.description,
      owner: %{
        id: owner.id,
        username: owner.username
      },
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end

  defp data(project) do
    %{
      id: project.id,
      name: project.name,
      description: project.description,
      owner_id: project.owner_id,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end
end

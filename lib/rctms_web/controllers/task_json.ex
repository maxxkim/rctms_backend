defmodule RCTMSWeb.TaskJSON do
  @doc """
  Renders a list of tasks.
  """
  def index(%{tasks: tasks}) do
    %{data: for(task <- tasks, do: data(task))}
  end

  @doc """
  Renders a single task.
  """
  def show(%{task: task}) do
    %{data: data(task)}
  end

  defp data(%{assignee: assignee, creator: creator} = task) when not is_nil(assignee) and not is_nil(creator) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      due_date: task.due_date,
      project_id: task.project_id,
      assignee: %{
        id: assignee.id,
        username: assignee.username,
        email: assignee.email
      },
      creator: %{
        id: creator.id,
        username: creator.username,
        email: creator.email
      },
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

  defp data(%{creator: creator} = task) when not is_nil(creator) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      due_date: task.due_date,
      project_id: task.project_id,
      assignee: nil,
      creator: %{
        id: creator.id,
        username: creator.username,
        email: creator.email
      },
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

  defp data(task) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      due_date: task.due_date,
      project_id: task.project_id,
      assignee_id: task.assignee_id,
      creator_id: task.creator_id,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
end

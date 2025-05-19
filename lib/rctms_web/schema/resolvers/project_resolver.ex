defmodule RCTMSWeb.Resolvers.ProjectResolver do
  alias RCTMS.Projects

  @doc """
  Get a project by ID
  """
  def get_project(%{id: id}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id == current_user.id ->
        {:ok, project}

      true ->
        # Here we could implement additional checking for project members
        # For now, only owners can access their projects
        {:error, "Not authorized to access this project"}
    end
  end

  def get_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  List all projects for the current user
  """
  def list_projects(%{filter: filter}, %{context: %{current_user: current_user}}) do
    # Преобразование атомов в строки для Projects.list_user_projects_paginated
    string_params = for {k, v} <- filter, into: %{}, do: {Atom.to_string(k), v}

    projects = Projects.list_user_projects_paginated(current_user.id, string_params)

    {:ok, %{
      entries: projects.entries,
      page_number: projects.page_number,
      page_size: projects.page_size,
      total_entries: projects.total_entries,
      total_pages: projects.total_pages
    }}
  end

  def list_projects(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Create a new project
  """
  def create_project(%{input: project_params}, %{context: %{current_user: current_user}}) do
    # Add owner_id to project parameters
    project_params = Map.put(project_params, :owner_id, current_user.id)

    case Projects.create_project(project_params) do
      {:ok, project} ->
        # Comment out or remove this line:
        # Absinthe.Subscription.publish(RCTMSWeb.Endpoint, project, project_created: current_user.id)

        {:ok, project}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def create_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Update a project
  """
  def update_project(%{id: id, input: project_params}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id != current_user.id ->
        {:error, "Not authorized to update this project"}

      true ->
        case Projects.update_project(project, project_params) do
          {:ok, updated_project} ->
            # Publish the event for subscriptions
            Absinthe.Subscription.publish(RCTMSWeb.Endpoint, updated_project, project_updated: id)
            {:ok, updated_project}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  def update_project(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Delete a project
  """
  def delete_project(%{id: id}, %{context: %{current_user: current_user}}) do
    project = Projects.get_project(id)

    cond do
      is_nil(project) ->
        {:error, "Project not found"}

      project.owner_id != current_user.id ->
        {:error, "Not authorized to delete this project"}

      true ->
        case Projects.delete_project(project) do
          {:ok, deleted_project} ->
            {:ok, deleted_project}

          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  def delete_project(_args, _resolution) do
    {:error, "Not authenticated"}
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

 # lib/rctms_web/schema/resolvers/project_resolver.ex (добавить метод)

@doc """
List projects with pagination
"""
def list_projects_paginated(%{filter: filter}, %{context: %{current_user: current_user}}) do
  # Преобразование атомов в строки для Projects.list_user_projects_paginated
  string_params = for {k, v} <- filter, into: %{}, do: {Atom.to_string(k), v}

  projects = Projects.list_user_projects_paginated(current_user.id, string_params)

  {:ok, %{
    entries: projects.entries,
    page_number: projects.page_number,
    page_size: projects.page_size,
    total_entries: projects.total_entries,
    total_pages: projects.total_pages
  }}
end

def list_projects_paginated(_args, _resolution) do
  {:error, "Not authenticated"}
end

end

defmodule RCTMS.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias RCTMS.Repo
  alias RCTMS.Projects.Project

  @doc """
  Returns the list of projects.
  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.
  """
  def get_project(id), do: Repo.get(Project, id)

  @doc """
  Gets a single project with preloaded associations.
  """
  def get_project_with_details(id) do
    Project
    |> Repo.get(id)
    |> Repo.preload([:owner, tasks: [:assignee, :creator]])
  end

  @doc """
  Get projects owned by a user.
  """
  def list_user_projects(user_id) do
    Project
    |> where([p], p.owner_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a project.
  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.
  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.
  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns a dataloader source for Projects data.
  This enables efficient loading of associations.
  """
  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @doc """
  Custom query function for dataloader to support filtering.
  """
  def query(queryable, _params) do
    queryable
  end
 @doc """
  Returns a paginated list of projects.

  ## Examples

      iex> list_projects_paginated(%{"page" => 1, "per_page" => 10})
      %{entries: [%Project{}, ...], page_number: 1, page_size: 10, total_entries: 30, total_pages: 3}

  """
  def list_projects_paginated(params \\ %{}) do
    page = Map.get(params, "page", 1)
    per_page = Map.get(params, "per_page", 10)

    Project
    |> filter_by_name(params)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page, page_size: per_page)
  end

  @doc """
  Returns a paginated list of projects for a user.

  ## Examples

      iex> list_user_projects_paginated(user_id, %{"page" => 1, "per_page" => 10})
      %{entries: [%Project{}, ...], page_number: 1, page_size: 10, total_entries: 15, total_pages: 2}

  """
  def list_user_projects_paginated(user_id, params \\ %{}) do
    page = Map.get(params, "page", 1)
    per_page = Map.get(params, "per_page", 10)

    Project
    |> where([p], p.owner_id == ^user_id)
    |> filter_by_name(params)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page, page_size: per_page)
  end

  defp filter_by_name(query, %{"search" => search}) when is_binary(search) and search != "" do
    search_term = "%#{search}%"
    where(query, [p], ilike(p.name, ^search_term) or ilike(p.description, ^search_term))
  end

  defp filter_by_name(query, _), do: query
end

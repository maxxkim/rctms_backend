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
end

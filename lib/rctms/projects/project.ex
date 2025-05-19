defmodule RCTMS.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string

    belongs_to :owner, RCTMS.Accounts.User
    has_many :tasks, RCTMS.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :owner_id])
    |> validate_required([:name, :owner_id])
    |> validate_length(:name, min: 3, max: 100)
    |> foreign_key_constraint(:owner_id)
  end
end

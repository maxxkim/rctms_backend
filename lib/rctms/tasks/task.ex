defmodule RCTMS.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :string, default: "pending" # pending, in_progress, completed
    field :priority, :string, default: "medium" # low, medium, high
    field :due_date, :utc_datetime

    belongs_to :project, RCTMS.Projects.Project
    belongs_to :assignee, RCTMS.Accounts.User
    belongs_to :creator, RCTMS.Accounts.User
    has_many :comments, RCTMS.Collaboration.Comment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :priority, :due_date, :project_id, :assignee_id, :creator_id])
    |> validate_required([:title, :status, :priority, :project_id, :creator_id])
    |> validate_inclusion(:status, ["pending", "in_progress", "completed"])
    |> validate_inclusion(:priority, ["low", "medium", "high"])
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:assignee_id)
    |> foreign_key_constraint(:creator_id)
  end
end

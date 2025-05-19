defmodule RCTMS.Collaboration.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :task, RCTMS.Tasks.Task
    belongs_to :user, RCTMS.Accounts.User

    timestamps(type: :utc_datetime)  # Changed from default type
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :task_id, :user_id])
    |> validate_required([:content, :task_id, :user_id])
    |> foreign_key_constraint(:task_id)
    |> foreign_key_constraint(:user_id)
  end
end

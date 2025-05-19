# priv/repo/migrations/TIMESTAMP_create_tasks.exs
defmodule RCTMS.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :string, null: false, default: "pending"
      add :priority, :string, null: false, default: "medium"
      add :due_date, :utc_datetime
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :assignee_id, references(:users, on_delete: :nilify_all)
      add :creator_id, references(:users, on_delete: :nilify_all), null: false

      timestamps()
    end

    create index(:tasks, [:project_id])
    create index(:tasks, [:assignee_id])
    create index(:tasks, [:creator_id])
  end
end

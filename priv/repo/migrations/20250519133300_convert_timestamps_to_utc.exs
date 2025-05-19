defmodule RCTMS.Repo.Migrations.ConvertTimestampsToUtc do
  use Ecto.Migration

  def change do
    # Users table
    alter table(:users) do
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end

    # Projects table
    alter table(:projects) do
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end

    # Tasks table
    alter table(:tasks) do
      # Also convert the due_date if present
      modify :due_date, :utc_datetime, from: :naive_datetime, null: true
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end

    # Comments table
    alter table(:comments) do
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end
  end
end

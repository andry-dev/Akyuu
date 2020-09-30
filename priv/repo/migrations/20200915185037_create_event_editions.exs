defmodule Akyuu.Repo.Migrations.CreateEventEditions do
  use Ecto.Migration

  def change do
    create table(:event_editions) do
      add :event_id, references(:events), on_delete: :delete_all, on_update: :update_all
      add :edition, :integer, null: false, default: 1
      add :start_date, :date, null: false
      add :end_date, :date, null: false

      timestamps()
    end
  end
end

defmodule Akyuu.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :romaji_name, :string
      add :abbreviation, :string
      add :edition, :integer, null: false, default: 1
      add :start_date, :date, null: false
      add :end_date, :date, null: false

      timestamps()
    end

    create unique_index(:events, [:name, :edition])
  end
end

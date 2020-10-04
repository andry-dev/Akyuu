defmodule Akyuu.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :text, null: false
      add :english_name, :text, null: false
      add :romaji_name, :text
      add :abbreviation, :text

      timestamps()
    end

    create unique_index(:events, [:name])
  end
end

defmodule Akyuu.Repo.Migrations.CreateMember do
  use Ecto.Migration
  import Akyuu.Migration

  def change do
    create table(:members) do
      add :name, :text, null: false
      add :romaji_name, :text
      add :english_name, :text

      timestamps()
    end

    create unique_index(:members, [:name])

    create_fulltext_index(:members, [:name, :romaji_name, :english_name])
  end
end

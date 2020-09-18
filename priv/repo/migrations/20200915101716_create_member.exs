defmodule Akyuu.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string, null: false
      add :romaji_name, :string
      add :english_name, :string

      timestamps()
    end

    create unique_index(:members, [:name])
  end
end

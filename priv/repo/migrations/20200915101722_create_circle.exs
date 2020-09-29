defmodule Akyuu.Repo.Migrations.CreateCircle do
  use Ecto.Migration
  import Akyuu.Migration

  def change do
    create table(:circles) do
        add :name, :text, null: false
        add :romaji_name, :text
        add :english_name, :text

        timestamps()
    end

    create unique_index(:circles, [:name])

    create_fulltext_index(:circles, [:name, :romaji_name, :english_name])
  end
end

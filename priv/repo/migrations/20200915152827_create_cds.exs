defmodule Akyuu.Repo.Migrations.CreateCDs do
  use Ecto.Migration

  import Akyuu.Migration

  def change do
    create table(:cds) do
      add :number, :integer, null: false
      add :title, :text
      add :romaji_title, :text
      add :english_title, :text
      add :is_hidden, :boolean

      timestamps()
    end

    create_fulltext_index(:cds, [:title, :romaji_title, :english_title])
  end
end

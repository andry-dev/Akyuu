defmodule Akyuu.Repo.Migrations.CreateAlbums do
  use Ecto.Migration
  import Akyuu.Migration

  def change do
    create table(:albums) do
      add :label, :"varchar(10)"
      add :title, :text
      add :romaji_title, :text
      add :english_title, :text
      add :xfd_url, :string
      add :cover_art_path, :string

      timestamps()
    end

    create unique_index(:albums, [:label])

    create_fulltext_index(:albums, [:label, :title, :romaji_title, :english_title])
  end
end

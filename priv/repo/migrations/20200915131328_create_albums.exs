defmodule Akyuu.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :label, :string
      add :title, :string
      add :romaji_title, :string
      add :english_title, :string
      add :xfd_url, :string
      add :cover_art_path, :string

      timestamps()
    end

    create unique_index(:albums, [:label])
  end
end

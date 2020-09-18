defmodule Akyuu.Repo.Migrations.CreateCirclesAlbums do
  use Ecto.Migration

  def change do
    create table(:circles_albums, primary_key: false) do
      add :circle_id, references(:circles), primary_key: true
      add :album_id, references(:albums), primary_key: true

      timestamps()
    end
  end
end

defmodule Akyuu.Repo.Migrations.CreateAlbumsTracks do
  use Ecto.Migration

  def change do
    create table(:albums_tracks, primary_key: false) do
      add :album_id, references(:albums), primary_key: true
      add :track_id, references(:tracks), primary_key: true

      timestamps()
    end
  end
end

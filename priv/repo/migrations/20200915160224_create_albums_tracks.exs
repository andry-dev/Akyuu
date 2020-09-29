defmodule Akyuu.Repo.Migrations.CreateAlbumsTracks do
  use Ecto.Migration

  def change do
    create table(:albums_tracks, primary_key: false) do
      add :album_id, references(:albums), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :track_id, references(:tracks), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end

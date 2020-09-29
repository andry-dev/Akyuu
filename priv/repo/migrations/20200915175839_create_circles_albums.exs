defmodule Akyuu.Repo.Migrations.CreateCirclesAlbums do
  use Ecto.Migration

  def change do
    create table(:circles_albums, primary_key: false) do
      add :circle_id, references(:circles), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :album_id, references(:albums), primary_key: true, on_delete: :delete_all, on_update: :delete_all

      timestamps()
    end
  end
end

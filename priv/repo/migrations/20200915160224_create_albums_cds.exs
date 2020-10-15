defmodule Akyuu.Repo.Migrations.CreateAlbumsCDs do
  use Ecto.Migration

  def change do
    create table(:albums_cds, primary_key: false) do
      add :album_id, references(:albums), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :cd_id, references(:cds), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end

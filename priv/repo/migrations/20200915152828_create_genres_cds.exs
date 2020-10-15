defmodule Akyuu.Repo.Migrations.CreateGenresCDs do
  use Ecto.Migration

  def change do
    create table(:genres_cds, primary_key: false) do
      add :cd_id, references(:cds), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :genre_id, references(:genres), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end

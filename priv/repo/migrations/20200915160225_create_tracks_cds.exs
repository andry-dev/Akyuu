defmodule Akyuu.Repo.Migrations.CreateTracksCDs do
  use Ecto.Migration

  def change do
    create table(:tracks_cds, primary_key: false) do
      add :track_id, references(:tracks), primary_key: true, on_delete: :delete_all, on_update: :update_all
      add :cd_id, references(:cds), primary_key: true, on_delete: :delete_all, on_update: :update_all

      timestamps()
    end
  end
end

defmodule Akyuu.Repo.Migrations.CreateTracksMembers do
  use Ecto.Migration

  def change do
    create table(:tracks_members) do
      add :track_id, references(:tracks), null: false, on_delete: :delete_all, on_update: :update_all
      add :member_id, references(:members), null: false, on_delete: :delete_all, on_update: :update_all
    end

    create unique_index(:tracks_members, [:track_id, :member_id])
  end
end

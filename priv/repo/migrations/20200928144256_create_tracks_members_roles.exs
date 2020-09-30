defmodule Akyuu.Repo.Migrations.CreateTracksMembersRoles do
  use Ecto.Migration

  def change do
    create table(:tracks_members_roles) do
      add :participation_id, references(:tracks_members), null: false, on_delete: :delete_all, on_update: :update_all

      add :role_id, references(:roles), null: false, on_delete: :delete_all, on_update: :update_all
    end

    create unique_index(:tracks_members_roles, [:participation_id, :role_id])
  end
end

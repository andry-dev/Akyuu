defmodule Akyuu.Repo.Migrations.CreateCircleMembersRoles do
  use Ecto.Migration

  def change do
    create table(:circles_members_roles) do
      add :participation_id, references(:circles_members), null: false, on_delete: :delete_all, on_update: :update_all
      add :role_id, references(:roles), null: false, on_delete: :delete_all, on_update: :update_all
    end

    create unique_index(:circles_members_roles, [:participation_id, :role_id])
  end
end

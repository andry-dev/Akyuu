defmodule Akyuu.Repo.Migrations.CreateCirclesMembers do
  use Ecto.Migration

  def change do
    create table(:circles_members) do
      add :member_id, references(:members), null: false, on_delete: :delete_all, on_update: :update_all
      add :circle_id, references(:circles), null: false, on_delete: :delete_all, on_update: :update_all
    end
  end
end

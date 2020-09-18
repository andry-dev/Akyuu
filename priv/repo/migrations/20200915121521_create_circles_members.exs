defmodule Akyuu.Repo.Migrations.CreateCirclesMembers do
  use Ecto.Migration

  def change do
    create table(:circles_members, primary_key: false) do
      add :role, :string

      add :member_id, references(:members), [primary_key: true]
      add :circle_id, references(:circles), [primary_key: true]

      timestamps()
    end
  end
end

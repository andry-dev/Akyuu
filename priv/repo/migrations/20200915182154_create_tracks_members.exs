defmodule Akyuu.Repo.Migrations.CreateTracksMembers do
  use Ecto.Migration

  def change do
    create table(:tracks_members, primary_key: false) do
      add :role, :string, null: false

      add :track_id, references(:tracks), primary_key: true
      add :member_id, references(:members), primary_key: true

      timestamps()
    end
  end
end

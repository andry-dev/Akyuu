defmodule Akyuu.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  import Akyuu.Migration

  def change do
    execute "create extension pgroonga;"

    create table(:users) do
      add :username, :text
      add :email, :string
      add :password_hash, :binary
      add :is_public, :boolean, default: false
      add :is_indexed, :boolean, default: false

      timestamps()
    end

    create_fulltext_index(:users, [:username])
  end
end

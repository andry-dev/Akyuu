defmodule Akyuu.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :binary
      add :is_public, :boolean, default: false
      add :is_indexed, :boolean, default: false

      timestamps()
    end
  end
end

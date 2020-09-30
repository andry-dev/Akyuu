defmodule Akyuu.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE role AS ENUM('arrangement', 'vocals', 'lyrics', 'illustration')"

    create table(:roles) do
      add :name, :role, null: false

      timestamps()
    end
  end
end

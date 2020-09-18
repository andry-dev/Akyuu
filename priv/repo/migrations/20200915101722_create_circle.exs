defmodule Akyuu.Repo.Migrations.CreateCircle do
  use Ecto.Migration

  def change do
    create table(:circles) do
        add :name, :string, null: false
        add :romaji_name, :string
        add :english_name, :string

        timestamps()
    end

    create unique_index(:circles, [:name])
  end
end

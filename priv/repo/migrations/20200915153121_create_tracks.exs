defmodule Akyuu.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :cd_number, :integer
      add :track_number, :integer
      add :title, :string
      add :romaji_title, :string
      add :english_title, :string
      add :is_hidden, :boolean, default: false

      timestamps()
    end

    create unique_index(:tracks, [:id, :cd_number, :track_number])
  end
end

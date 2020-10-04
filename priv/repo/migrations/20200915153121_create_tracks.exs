defmodule Akyuu.Repo.Migrations.CreateTracks do
  use Ecto.Migration
  import Akyuu.Migration

  def change do
    create table(:tracks) do
      add :cd_number, :integer
      add :track_number, :integer
      add :title, :text
      add :romaji_title, :text
      add :english_title, :text
      add :length, :integer
      add :is_hidden, :boolean, default: false

      timestamps()
    end

    create unique_index(:tracks, [:id, :cd_number, :track_number])

    create_fulltext_index(:tracks, [:title, :romaji_title, :english_title])
  end
end

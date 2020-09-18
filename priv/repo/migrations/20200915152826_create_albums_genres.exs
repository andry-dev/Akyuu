defmodule Akyuu.Repo.Migrations.CreateAlbumsGenres do
  use Ecto.Migration

  def change do
    create table(:albums_genres, primary_key: false) do
      add :album_id, references(:albums), [primary_key: true]
      add :genre_id, references(:genres), [primary_key: true]

      timestamps()
    end
  end
end

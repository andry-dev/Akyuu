defmodule Akyuu.AlbumGenre do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "album_genres" do
    belongs_to :album, Akyuu.Album, primary_key: true
    belongs_to :genre, Akyuu.Genre, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(album_genre, attrs) do
    album_genre
    |> cast(attrs, [:album_id, :genre_id])
  end
end

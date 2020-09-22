defmodule Akyuu.Music.AlbumTrack do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "albums_tracks" do
    belongs_to :album, Akyuu.Music.Album, primary_key: true
    belongs_to :track, Akyuu.Music.Track, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(albums_tracks, attrs) do
    albums_tracks
    |> cast(attrs, [:album_id, :track_id])
  end
end

defmodule Akyuu.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :label, :string
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :xfd_url, :string
    field :cover_art_path, :string

    many_to_many :track, Akyuu.Track, join_through: Akyuu.AlbumTrack
    many_to_many :genre, Akyuu.Genre, join_through: Akyuu.AlbumGenre
    many_to_many :event, Akyuu.Event, join_through: Akyuu.AlbumEvent
    many_to_many :circle, Akyuu.Circle, join_through: Akyuu.CircleAlbum
    many_to_many :user_wants, Akyuu.User, join_through: Akyuu.UserWishlist

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:label, :title, :romaji_title, :english_title, :xfd_url, :cover_art_path])
    |> validate_required([:label, :title])
    |> unique_constraint([:label])
  end
end

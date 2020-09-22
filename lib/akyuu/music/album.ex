defmodule Akyuu.Music.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :label, :string
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :xfd_url, :string
    field :cover_art_path, :string

    many_to_many :track, Akyuu.Music.Track, join_through: Akyuu.Music.AlbumTrack
    many_to_many :genre, Akyuu.Music.Genre, join_through: Akyuu.Music.AlbumGenre
    many_to_many :event, Akyuu.Music.Event, join_through: Akyuu.Music.AlbumEvent
    many_to_many :circle, Akyuu.Music.Circle, join_through: Akyuu.Music.CircleAlbum
    many_to_many :user_wants, Akyuu.Accounts.User, join_through: Akyuu.Accounts.UserWishlist, on_replace: :delete

    timestamps()
  end

  @required_fields ~w(label title romaji_title english_title xfd_url cover_art_path)a

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, @required_fields)
    |> validate_required([:label, :title])
    |> unique_constraint([:label])
  end
end

defmodule Akyuu.Music.Track do
  @moduledoc """
  A track present in one or more album, created by one or more members of one
  or more circles.

  See `Akyuu.Music.Circle`.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @type t :: %__MODULE__{
          title: String.t(),
          romaji_title: String.t(),
          english_title: String.t(),
          cd_number: integer(),
          track_number: integer(),
          hidden?: boolean(),
          albums: [Akyuu.Music.Album.t()],
          members: [Akyuu.Music.Member.t()]
        }

  schema "tracks" do
    field :cd_number, :integer
    field :track_number, :integer
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :hidden?, :boolean, source: :is_hidden, default: false

    many_to_many :albums, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumTrack
    many_to_many :members, Akyuu.Music.Member, join_through: Akyuu.Music.TrackMember

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :cd_number,
      :track_number,
      :title,
      :romaji_title,
      :english_title,
      :hidden?
    ])
    |> validate_required([:cd_number, :track_number, :title])
  end

  def search(schema, name) do
    to_search = "%#{name}%"

    from track in schema,
      where: ilike(track.title, ^to_search),
      or_where: ilike(track.romaji_title, ^to_search),
      or_where: ilike(track.english_title, ^to_search)
  end
end

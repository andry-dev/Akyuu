defmodule Akyuu.Music.Track do
  @moduledoc """
  A track present in one or more CDs, created by one or more members of one
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
          number: integer(),
          length: integer(),
          hidden?: boolean(),
          cds: [Akyuu.Music.CD.t()],
          members: [Akyuu.Music.Member.t()]
        }

  schema "tracks" do
    field :number, :integer
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :length, :integer
    field :hidden?, :boolean, source: :is_hidden, default: false

    many_to_many :cds, Akyuu.Music.CD, join_through: Akyuu.Music.TrackCD

    has_many :performed_by_members, Akyuu.Music.TrackMember
    has_many :members, through: [:performed_by_members, :member]

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :number,
      :title,
      :romaji_title,
      :english_title,
      :length,
      :hidden?
    ])
    |> validate_required([:number, :title, :length])
    |> validate_number(:number, greater_than: 0)
  end

  def search(schema, name) do
    to_search = "%#{name}%"

    from track in schema,
      where: ilike(track.title, ^to_search),
      or_where: ilike(track.romaji_title, ^to_search),
      or_where: ilike(track.english_title, ^to_search)
  end
end

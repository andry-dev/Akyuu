defmodule Akyuu.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :cd_number, :integer
    field :track_number, :integer
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :hidden?, :boolean, source: :is_hidden, default: false

    many_to_many :album, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumTrack
    many_to_many :member, Akyuu.Music.Member, join_through: Akyuu.Music.TrackMember

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
    |> validate_required([:id, :cd_number, :track_number, :title])
  end
end

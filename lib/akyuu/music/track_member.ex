defmodule Akyuu.Music.TrackMemeber do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "tracks_members" do
    field :role, :string

    belongs_to :track, Akyuu.Music.Track, primary_key: true
    belongs_to :member, Akyuu.Music.Member, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(tracks_members, attrs) do
    tracks_members
    |> cast(attrs, [:role, :track_id, :member_id])
    |> validate_required([:role, :track_id, :member_id])
  end
end

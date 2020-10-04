defmodule Akyuu.Music.TrackMember do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "tracks_members" do
    belongs_to :track, Akyuu.Music.Track
    belongs_to :member, Akyuu.Music.Member

    many_to_many :roles, Akyuu.Music.Role,
      join_through: Akyuu.Music.TrackMemberRole,
      join_keys: [participation_id: :id, role_id: :id]
  end

  @doc false
  def changeset(tracks_members, attrs) do
    tracks_members
    |> cast(attrs, [:track_id, :member_id])
    |> unique_constraint([:track_id, :member_id])
    |> validate_required([:track_id, :member_id])
    |> foreign_key_constraint(:member_id)
    |> foreign_key_constraint(:track_id)
  end
end

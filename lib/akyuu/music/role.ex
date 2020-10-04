defmodule Akyuu.Music.Role do
  @moduledoc """
  A module that defines a role for a member.

  When a member of a circle creates a track, it usually has a role in it, for
  example by singing ("vocals"), composing it ("arrangement"), writing lyrics,
  etc...
  The same logic applies to the generic role of a member of a circle.

  In both of these cases, a member may have more than one role.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string

    many_to_many :circle_members, Akyuu.Music.CircleMember,
      join_through: Akyuu.Music.CircleMemberRole,
      join_keys: [role_id: :id, participation_id: :id]

    many_to_many :track_members, Akyuu.Music.TrackMember,
      join_through: Akyuu.Music.TrackMemberRole,
      join_keys: [role_id: :id, participation_id: :id]

    timestamps()
  end

  def changeset(role, attrs \\ %{}) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end

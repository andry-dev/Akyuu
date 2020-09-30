defmodule Akyuu.Music.Role do
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

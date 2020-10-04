defmodule Akyuu.Music.CircleMember do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "circles_members" do
    belongs_to :circle, Akyuu.Music.Circle
    belongs_to :member, Akyuu.Music.Member

    many_to_many :roles, Akyuu.Music.Role,
      join_through: Akyuu.Music.CircleMemberRole,
      join_keys: [participation_id: :id, role_id: :id]
  end

  @doc false
  def changeset(circle_member, attrs) do
    circle_member
    |> cast(attrs, [:circle_id, :member_id])
    |> validate_required([:circle_id, :member_id])
    |> foreign_key_constraint(:circle_id)
    |> foreign_key_constraint(:member_id)
    |> unique_constraint([:circle_id, :member_id])
  end
end

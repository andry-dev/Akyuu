defmodule Akyuu.Music.TrackMemberRole do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "tracks_members_roles" do
    belongs_to :participation, Akyuu.Music.TrackMember
    belongs_to :role, Akyuu.Music.Role
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [:participation_id, :role_id])
    |> unique_constraint([:participation_id, :role_id])
    |> validate_required([:participation_id, :role_id])
    |> foreign_key_constraint(:participation_id)
    |> foreign_key_constraint(:role_id)
  end
end

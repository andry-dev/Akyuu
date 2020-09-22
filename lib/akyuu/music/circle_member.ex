defmodule Akyuu.Music.CircleMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "circles_members" do
    field :role, :string

    belongs_to :circle, Akyuu.Music.Circle, primary_key: true
    belongs_to :member, Akyuu.Music.Member, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(circle_member, attrs) do
    circle_member
    |> cast(attrs, [:circle_id, :member_id, :role])
    |> validate_required([:circle_id, :member_id])
    |> foreign_key_constraint(:circle_id)
    |> foreign_key_constraint(:member_id)
    |> unique_constraint([:circle_id, :member_id])
  end
end

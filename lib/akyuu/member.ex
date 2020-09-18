defmodule Akyuu.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    many_to_many :circle, Akyuu.Circle, join_through: Akyuu.CircleMember
    many_to_many :track, Akyuu.Track, join_through: Akyuu.TrackMember

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end

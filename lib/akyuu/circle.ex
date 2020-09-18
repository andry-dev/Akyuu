defmodule Akyuu.Circle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "circles" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    many_to_many :members, Akyuu.Member, join_through: Akyuu.CircleMember

    timestamps()
  end

  @doc false
  def changeset(circle, attrs) do
    circle
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end

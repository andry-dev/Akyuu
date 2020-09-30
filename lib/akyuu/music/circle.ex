defmodule Akyuu.Music.Circle do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "circles" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    many_to_many :members, Akyuu.Music.Member, join_through: Akyuu.Music.CircleMember

    timestamps()
  end

  @doc false
  def changeset(circle, attrs) do
    circle
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  def search(schema, name) do
    to_search = "%#{name}%"

    from circle in schema,
      where: ilike(circle.name, ^to_search),
      or_where: ilike(circle.romaji_name, ^to_search),
      or_where: ilike(circle.english_name, ^to_search)
  end
  end
end

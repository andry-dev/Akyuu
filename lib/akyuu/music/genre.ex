defmodule Akyuu.Music.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    field :name, :string

    many_to_many :album, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumGenre

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end

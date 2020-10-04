defmodule Akyuu.Music.Genre do
  @moduledoc """
  Describes a genre attached to an album.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          albums: [Akyuu.Music.Album.t()]
        }

  schema "genres" do
    field :name, :string

    many_to_many :albums, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumGenre

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

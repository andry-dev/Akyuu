defmodule Akyuu.Music.GenreCD do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "genres_cds" do
    belongs_to :cd, Akyuu.Music.CD, primary_key: true
    belongs_to :genre, Akyuu.Music.Genre, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(changeset_or_struct, attrs) do
    changeset_or_struct
    |> cast(attrs, [:cd_id, :genre_id])
    |> foreign_key_constraint(:cd_id)
    |> foreign_key_constraint(:genre_id)
  end
end

defmodule Akyuu.Music.AlbumCD do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "albums_cds" do
    belongs_to :album, Akyuu.Music.Album, primary_key: true
    belongs_to :cd, Akyuu.Music.CD, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(struct_or_changeset, attrs) do
    struct_or_changeset
    |> cast(attrs, [:album_id, :cd_id])
    |> unique_constraint([:album_id, :cd_id])
    |> foreign_key_constraint(:album_id)
    |> foreign_key_constraint(:member_id)
  end
end

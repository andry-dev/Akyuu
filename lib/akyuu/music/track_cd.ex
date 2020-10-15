defmodule Akyuu.Music.TrackCD do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "tracks_cds" do
    belongs_to :track, Akyuu.Music.Track, primary_key: true
    belongs_to :cd, Akyuu.Music.CD, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(struct_or_changeset, attrs) do
    struct_or_changeset
    |> cast(attrs, [:track_id, :cd_id])
    |> unique_constraint([:track_id, :cd_id])
    |> foreign_key_constraint(:track_id)
    |> foreign_key_constraint(:cd_id)
  end
end

defmodule Akyuu.Music.AlbumEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "albums_events" do
    field :price_jpy, :integer, default: 1000

    belongs_to :album, Akyuu.Music.Album, primary_key: true
    belongs_to :event, Akyuu.Music.EventEdition, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(albums_events, attrs) do
    albums_events
    |> cast(attrs, [:price_jpy, :album_id, :event_id])
    |> validate_length(:price_jpy, min: 0)
  end
end

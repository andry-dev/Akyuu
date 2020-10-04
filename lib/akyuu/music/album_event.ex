defmodule Akyuu.Music.AlbumEvent do
  @moduledoc """
  Association between an album and an event edition.

  When an album is released at an edition, it has a price tag attached to it.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @typedoc """
  ## Attributes
  - `:price_jpy`: A non-negative integer describing how much the album costs
    at that event in Japanese Yens.
  """
  @type t :: %__MODULE__{
          price_jpy: non_neg_integer()
        }

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
    |> validate_required([:price_jpy])
    |> validate_number(:price_jpy, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:album_id)
    |> foreign_key_constraint(:event_id)
  end
end

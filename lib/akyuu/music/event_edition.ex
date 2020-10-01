defmodule Akyuu.Music.EventEdition do
  use Ecto.Schema

  import Ecto.Changeset

  alias Akyuu.Music.{Event, Album, AlbumEvent}
  alias Akyuu.Repo

  @type t :: %__MODULE__{
          edition: non_neg_integer(),
          start_date: Date.t(),
          end_date: Date.t(),
          albums: [Akyuu.Music.Album.t()],
          event: [Akyuu.Music.Event.t()]
        }

  schema "event_editions" do
    field :edition, :integer, default: 1
    field :start_date, :date
    field :end_date, :date

    many_to_many :albums, Album,
      join_through: AlbumEvent,
      join_keys: [event_id: :id, album_id: :id]

    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(event_editions, attrs \\ %{}) do
    event_editions
    |> cast(attrs, [:event_id, :edition, :start_date, :end_date])
    |> validate_required([:edition, :start_date])
    |> unique_constraint([:edition])
    |> foreign_key_constraint(:event_id)
  end
end

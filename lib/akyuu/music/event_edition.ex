defmodule Akyuu.Music.EventEdition do
  use Ecto.Schema

  import Ecto.Changeset

  alias Akyuu.Music.{Event, Album, AlbumEvent}

  schema "event_editions" do
    field :edition, :integer, default: 1
    field :start_date, :date
    field :end_date, :date

    many_to_many :albums, Album, join_through: AlbumEvent

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

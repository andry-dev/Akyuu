defmodule Akyuu.Music.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :romaji_name, :string
    field :abbreviation, :string
    field :edition, :integer, default: 1
    field :start_date, :date
    field :end_date, :date

    many_to_many :album, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumEvent

    timestamps()
  end

  @doc false
  def changeset(events, attrs) do
    events
    |> cast(attrs, [:name, :romaji_name, :abbreviation, :edition, :start_date, :end_date])
    |> validate_required([:name, :edition, :start_date, :end_date])
    |> unique_constraint([:name, :edition])
  end
end

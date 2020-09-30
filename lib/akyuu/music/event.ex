defmodule Akyuu.Music.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Music.{Event, Album, AlbumEvent, EventEdition}
  alias Akyuu.Repo

  schema "events" do
    field :name, :string
    field :romaji_name, :string
    field :abbreviation, :string

    has_many :editions, EventEdition

    timestamps()
  end

  @doc false
  def changeset(events, attrs) do
    events
    |> cast(attrs, [:name, :romaji_name, :abbreviation])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  def add_album(%EventEdition{} = edition, %Album{} = album, opts \\ []) do
    changeset_attrs =
      Map.from_struct(
        Kernel.struct(
          %AlbumEvent{
            album_id: album.id,
            event_id: edition.event_id
          },
          opts
        )
      )

    %AlbumEvent{}
    |> AlbumEvent.changeset(changeset_attrs)
    |> Repo.insert()
  end

  def generate(:comiket) do
    %Event{
      name: "コミックマーケット",
      romaji_name: "Komikku Maketto",
      abbreviation: "comiket"
    }
  end

  def generate(:reitaisai) do
    %Event{
      name: "博麗神社例大祭",
      romaji_name: "Hakurei Jinja Reitaisai",
      abbreviation: "reitaisai"
    }
  end

  def generate(:autumn_reitaisai) do
    %Event{
      name: "博麗神社秋季例大祭",
      romaji_name: "Hakurei Jinja Shuuki Reitaisai",
      abbreviation: "shuuki reitaisai"
    }
  end

  def generate(:m3) do
    %Event{name: "M3", abbreviation: "m3"}
  end

  @spec find_event(name :: atom(), edition :: integer()) :: Ecto.Schema.t()
  def find_event(name, edition) do
    abbr = generate(name).abbreviation

    query =
      from event_edition in EventEdition,
        join: event in assoc(event_edition, :event),
        where: event.abbreviation == ^abbr,
        where: event_edition.edition == ^edition

    Repo.one(query)
  end
end

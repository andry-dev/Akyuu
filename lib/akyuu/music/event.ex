defmodule Akyuu.Music.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Music.{Event, Album, AlbumEvent, EventEdition}
  alias Akyuu.Repo

  @moduledoc """
  An event is any convention where doujin albums are released. It has one or
  more editions, each of which starts at a specific date and lasts for one or
  more days.

  Usually an event runs one or more editions annually, for example the
  Comic Market (Comiket) runs bi-annually: an edition in summer (generally in
  August) and the other in winter (generally at the end of December).
  """

  @type t :: %__MODULE__{
          name: String.t(),
          romaji_name: String.t(),
          abbreviation: String.t(),
          editions: [Akyuu.Music.EventEdition.t()]
        }

  @type event_name :: :comiket | :reitaisai | :autumn_reitaisai | :m3

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

  @doc """
  Given an atom that describes an event, automatically generate the `Event` struct for that event.

  This function is generally used to attach an edition to an event.

  ## Examples
  To generate a Comiket:

      iex> Music.Event.generate(:comiket)
      %Akyuu.Music.Event{
        __meta__: #Ecto.Schema.Metadata<:built, "events">,
        abbreviation: "comiket",
        editions: #Ecto.Association.NotLoaded<association :editions is not loaded>,
        id: nil,
        inserted_at: nil,
        name: "コミックマーケット",
        romaji_name: "Komikku Maketto",
        updated_at: nil
      }

  To generate a Reitaisai:

      iex> Music.Event.generate(:reitaisai)
      %Akyuu.Music.Event{
        __meta__: #Ecto.Schema.Metadata<:built, "events">,
        abbreviation: "reitaisai",
        editions: #Ecto.Association.NotLoaded<association :editions is not loaded>,
        id: nil,
        inserted_at: nil,
        name: "博麗神社例大祭",
        romaji_name: "Hakurei Jinja Reitaisai",
        updated_at: nil
      }
  """
  @spec generate(event :: event_name()) :: Event.t()
  def generate(event)

  def generate(:comiket) do
    %__MODULE__{
      name: "コミックマーケット",
      romaji_name: "Komikku Maketto",
      abbreviation: "comiket"
    }
  end

  def generate(:reitaisai) do
    %__MODULE__{
      name: "博麗神社例大祭",
      romaji_name: "Hakurei Jinja Reitaisai",
      abbreviation: "reitaisai"
    }
  end

  def generate(:autumn_reitaisai) do
    %__MODULE__{
      name: "博麗神社秋季例大祭",
      romaji_name: "Hakurei Jinja Shuuki Reitaisai",
      abbreviation: "shuuki reitaisai"
    }
  end

  def generate(:m3) do
    %__MODULE__{name: "M3", abbreviation: "m3"}
  end

  @doc """
  Tries to find an edition of the specified event.


  ## Examples
  To find the 97th edition of the Comiket:

      iex> find_event(:comiket, 97)
      %Akyuu.Music.EventEdition{
        __meta__: #Ecto.Schema.Metadata<:loaded, "event_editions">,
        albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
        edition: 97,
        end_date: ~D[2019-12-31],
        event: #Ecto.Association.NotLoaded<association :event is not loaded>,
        event_id: 1,
        id: 2,
        inserted_at: ~N[2020-09-29 12:54:36],
        start_date: ~D[2019-12-28],
        updated_at: ~N[2020-09-29 12:54:36]
      }

      # As of October 1, 2020, Comiket 200 does not exist.
      iex> find_event(:comiket, 200)
      nil
  """
  @spec find_event(name :: event_name(), edition :: integer()) ::
          Akyuu.Music.EventEdition.t() | nil
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

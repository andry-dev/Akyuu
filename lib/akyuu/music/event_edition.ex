defmodule Akyuu.Music.EventEdition do
  @moduledoc """
  An event edition is an independent edition (or run) of an event that happened
  during a specific date.

  Albums are released in an edition.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Akyuu.Music.{Album, AlbumEvent, Event}
  alias Akyuu.Repo

  @type t :: %__MODULE__{
          edition: non_neg_integer(),
          start_date: Date.t(),
          end_date: Date.t(),
          albums: [Akyuu.Music.Album.t()],
          event: Akyuu.Music.Event.t()
        }

  schema "event_editions" do
    field :edition, :integer, default: 1
    field :start_date, :date
    field :end_date, :date

    has_many :albums, Akyuu.Music.AlbumEvent, foreign_key: :event_id

    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(event_editions, attrs \\ %{}) do
    event_editions
    |> cast(attrs, [:event_id, :edition, :start_date, :end_date])
    |> foreign_key_constraint(:event_id)
    |> validate_required([:edition, :start_date])
    |> unique_constraint([:edition])
    |> validate_number(:edition, greater_than: 0)
  end

  @doc """
  Creates a new edition of an event.

  This function automatically does validation of the struct.
  """
  @spec new(%{
          edition: non_neg_integer(),
          start_date: Date.t(),
          end_date: Date.t()
        }) ::
          {:ok, Ecto.Schema.t()} | {:error, :nil_argument | :validation_failed}
  def new(params) do
    cond do
      is_nil(Map.get(params, :edition)) or is_nil(Map.get(params, :start_date)) ->
        {:error, :nil_argument}

      !is_integer(params.edition) ->
        {:error, :validation_failed}

      params.edition <= 0 ->
        {:error, :validation_failed}

      true ->
        end_date =
          if is_nil(Map.get(params, :end_date)) do
            params.start_date
          else
            params.end_date
          end

        {:ok,
         %__MODULE__{
           edition: params.edition,
           start_date: params.start_date,
           end_date: end_date
         }}
    end
  end

  @doc """
  Adds an album to an edition.
  """
  @spec add_album(
          edition :: t(),
          album :: Album.t(),
          opts :: [price_jpy: non_neg_integer()]
        ) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_album(edition, album, opts \\ []) do
    changeset_attrs =
      opts
      |> Enum.into(%{})
      |> Map.put(:album_id, album.id)
      |> Map.put(:edition_id, edition.event_id)

    %AlbumEvent{}
    |> AlbumEvent.changeset(changeset_attrs)
    |> Repo.insert()
  end

  @spec abbreviation_to_string(event_edition :: t()) :: String.t()
  def abbreviation_to_string(event_edition) do
    "#{event_edition.event.abbreviation}#{event_edition.edition}"
  end
end

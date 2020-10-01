defmodule Akyuu.Music do
  alias Akyuu.Repo

  alias Akyuu.Music.{
          Album,
          Circle,
          Track,
          Member,
          Genre,
          Event,
          EventEdition,
          AlbumTrack,
          CircleMember,
          CircleAlbum,
          TrackMember
        },
        warn: false

  @moduledoc """
  Context for managing all the operations that are related to doujin music.
  For example, CRUD operations for albums, circles, events, tracks, members,
  etc...
  """

  @doc """
  Returns all the albums from the database without preloading anything.
  """
  @spec list_albums() :: Album.t() | [Album.t()] | nil
  def list_albums do
    Album
    |> Repo.all()
  end

  @doc """
  Returns all the albums from the database and preloads the attributes specified
  in the preload_list.

  ## Examples

  Here, the preloaded attribute is "events".

      iex> list_albums([:events])
      [
        %Akyuu.Music.Album{
          ...
          events: [
            %Akyuu.Music.EventEdition{
              ...
            }
          ],
        }
      ]
  """
  @spec list_albums(preload_list :: [atom()]) :: Album.t() | [Album.t()] | nil
  def list_albums(preload_list) when is_list(preload_list) do
    Album
    |> Repo.all()
    |> Repo.preload(preload_list)
  end

  @doc """
  Returns all the albums from the database with all the attributes preloaded.
  This function is extremely expensive since it queries all the database, please
  use it sparingly.
  """
  @spec list_albums_full() :: Album.t() | [Album.t()] | nil
  def list_albums_full do
    Album
    |> Repo.all()
    |> Repo.preload(circle: [:members], event: [], track: [member: :circle])
  end

  @doc """
  Returns all the albums from the database which partially match the given `name`.
  The search is case-insensitive.

  This function tries to match the original title (probably in japanese), the
  romaji version (if it exists), the english translation (if it exists) and
  finally the label of the album.


  ## Examples

  An album called "彁", with label "RDWL-0030" and with no romaji
  translitteration can be found by using any of the following:

      iex> search_albums("彁")
      [
        %Akyuu.Music.Album{...}
      ]

      iex> search_albums("rdwl-0030")
      [
        %Akyuu.Music.Album{...}
      ]

      # This will match all the albums which include "DW" in the label or in
      # any of the titles.
      iex> search_albums("DW")
      [
        %Akyuu.Music.Album{...},
        %Akyuu.Music.Album{...},
        %Akyuu.Music.Album{...},
        ...
      ]
  """
  @spec search_albums(name :: String.t()) :: Album.t() | [Album.t()] | nil
  def search_albums(name) do
    Album
    |> Album.search(name)
    |> Repo.all()
  end

  @doc """
  Returns all the circles from the database which partially match the given
  `name`.
  The search is case-insensitive.
  """
  @spec search_circles(name :: String.t()) :: Circle.t() | [Circle.t()] | nil
  def search_circles(name) do
    Circle
    |> Circle.search(name)
    |> Repo.all()
  end
  defp fill_event_date(opts) when is_list(opts) do
    if opts[:end_date] == nil do
      opts ++ [end_date: opts[:start_date]]
    else
      opts
    end
  end

  @doc """
  Creates a new event.
  """
  @spec create_event(name :: Event.event_name(), opts :: Keyword.t()) ::
          {:ok, EventEdition.t()} | {:error, Ecto.Changeset.t()}
  def create_event(name, opts) when is_list(opts) do
    event_name = Event.generate(name)

    found_event = Repo.get_by(Event, name: event_name.name) || Repo.insert!(event_name)

    changeset_attrs =
      opts
      |> fill_event_date()
      |> Enum.into(%{})
      |> Map.put(:event_id, found_event.id)

    %EventEdition{}
    |> EventEdition.changeset(changeset_attrs)
    |> Repo.insert()
  end
end

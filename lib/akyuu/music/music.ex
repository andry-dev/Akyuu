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
  Finds an album by its id.
  """
  @spec find_album_by_id(id :: non_neg_integer(), preload_list :: [atom()]) :: Album.t() | nil
  def find_album_by_id(id, preload_list \\ []) do
    Repo.get(Album, id)
    |> Repo.preload(preload_list)
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

  @doc """
  Returns all the members from the database which partially match the given
  `name`.
  The search is case-insensitive.
  """
  @spec search_members(String.t()) :: Member.t() | [Member.t()] | nil
  def search_members(name) do
    Member
    |> Member.search(name)
    |> Repo.all()
  end

  @doc """
  Returns all the tracks from the database which partially match the given
  `name`.
  The search is case-insensitive.
  """
  @spec search_tracks(String.t()) :: Track.t() | [Track.t()] | nil
  def search_tracks(name) do
    Track
    |> Track.search(name)
    |> Repo.all()
  end

  @doc """
  Creates a new album.
  """
  @spec create_album(attrs :: %{}) :: {:ok, Album.t()} | {:error, Ecto.Changeset.t()}
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new CD.
  """
  @spec create_cd(attrs :: %{}) :: {:ok, CD.t()} | {:error, Ecto.Changeset.t()}
  def create_cd(attrs \\ %{}) do
    %CD{}
    |> CD.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new circle.
  """
  @spec create_circle(attrs :: %{}) :: {:ok, Circle.t()} | {:error, Ecto.Changeset.t()}
  def create_circle(attrs \\ %{}) do
    %Circle{}
    |> Circle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new member.
  """
  @spec create_member(attrs :: %{}) :: {:ok, Member.t()} | {:error, Ecto.Changeset.t()}
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new event.
  """
  @spec create_event(
          name :: Event.event_name(),
          opts :: [edition: non_neg_integer(), start_date: Date.t(), end_date: Date.t()]
        ) ::
          {:ok, EventEdition.t()} | {:error, atom()} | {:error, Ecto.Changeset.t()}
  def create_event(name, opts) when is_list(opts) do
    event_name = Event.generate(name)

    found_event =
      Repo.get_by(Event, name: event_name.name) ||
        Repo.insert!(event_name)

    attrs = opts |> Enum.into(%{})

    case EventEdition.new(attrs) do
      {:ok, new_edition} ->
        new_edition
        |> EventEdition.changeset(%{event_id: found_event.id})
        |> Repo.insert()

      {:error, error_type} ->
        {:error, error_type}
    end
  end

  @doc """
  Creates a new genre.
  """
  @spec create_genre(attrs :: %{}) :: {:ok, Genre.t()} | {:error, Ecto.Changeset.t()}
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a new track.
  """
  @spec create_track(attrs :: %{}) :: {:ok, Track.t()} | {:error, Ecto.Changeset.t()}
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  def to_seconds(opts \\ [hour: 0, min: 0, sec: 0]) do
    hour = Keyword.get(opts, :hour, 0)
    min = Keyword.get(opts, :min, 0)
    sec = Keyword.get(opts, :sec, 0)

    hour * 3600 + min * 60 + sec
  end
end

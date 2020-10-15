defmodule Akyuu.Music do
  alias Akyuu.Repo

  import Ecto.Query

  alias Akyuu.Music.{
          Album,
          CD,
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

  defp generate_preloaded_album do
    from album in Album,
      left_join: circles in assoc(album, :circles),
      left_join: event_participations in assoc(album, :event_participations),
      left_join: edition in assoc(event_participations, :edition),
      left_join: event in assoc(edition, :event),
      left_join: cds in assoc(album, :cds),
      left_join: genres in assoc(cds, :genres),
      left_join: tracks in assoc(cds, :tracks),
      left_join: performed_by_members in assoc(tracks, :performed_by_members),
      left_join: roles in assoc(performed_by_members, :roles),
      left_join: member in assoc(performed_by_members, :member),
      preload: [
        circles: circles,
        event_participations: {
          event_participations,
          edition: {
            edition,
            event: event
          }
        },
        cds: {
          cds,
          genres: genres,
          tracks: {
            tracks,
            performed_by_members: {
              performed_by_members,
              roles: roles, member: member
            }
          }
        }
      ]
  end

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
  Returns all the albums from the database and preloads all the useful
  attributes in one query.
  This function is expensive since it queries all the database, please use it
  sparingly.
  """
  @spec list_albums(:preload_all) :: Album.t() | [Album.t()] | nil
  def list_albums(:preload_all) do
    Repo.all(generate_preloaded_album())
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
  def find_album_by_id(id, preload_list \\ [])

  @doc """
  Find an album by its id and preloads all useful fields in one query.
  """
  @spec find_album_by_id(id :: non_neg_integer(), :preload_all) :: Album.t() | nil
  def find_album_by_id(id, :preload_all) do
    query =
      generate_preloaded_album()
      |> where([album], album.id == ^id)

    Repo.one(query)
  end

  def find_album_by_id(id, preload_list) do
    Repo.get(Album, id)
    |> Repo.preload(preload_list)
  end

  def update_album(object, attrs, preload_list \\ [])

  @doc """
  Given the id of an album, updates its fields with a new changeset.
  """
  @spec update_album(id :: non_neg_integer(), attrs :: %{}, preload_list :: [atom()]) ::
          any()
  def update_album(id, attrs, preload_list) when is_integer(id) do
    with found_album when not is_nil(found_album) <- find_album_by_id(id) do
      changeset =
        found_album
        |> Repo.preload(preload_list)
        |> Album.changeset(attrs)
        |> Ecto.Changeset.cast_assoc(:tracks, with: &Track.changeset/2)

      if changeset.valid? do
        Repo.update(changeset)
      else
        {:error, changeset}
      end
    else
      _ -> {:error, :album_not_found}
    end
  end

  @doc """
  Given the id of an album, updates ALL its fields with a new changeset.
  """
  @spec update_album(id :: non_neg_integer(), attrs :: %{}, :preload_all) :: any()
  def update_album(id, attrs, :preload_all) when is_integer(id) do
    case find_album_by_id(id, :preload_all) do
      nil ->
        {:error, :album_not_found}

      album ->
        changeset =
          album
          |> Album.changeset(attrs)
          |> Ecto.Changeset.cast_assoc(:tracks, with: &Track.changeset/2)

        if changeset.valid? do
          Repo.update(changeset)
        else
          {:error, changeset}
        end
    end
  end

  @doc """
  Given the id of an album, updates its fields with a new changeset.
  """
  @spec update_album(album :: Album.t(), attrs :: %{}, preload_list :: [atom()]) ::
          any()
  def update_album(album = %Album{}, attrs, preload_list) do
    album
    |> Repo.preload(preload_list)
    |> Album.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:tracks, with: &Track.changeset/2)
    |> Repo.update()
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
  Finds an album by its id.
  """
  @spec find_circle_by_id(id :: non_neg_integer(), preload_list :: [atom()]) :: Circle.t() | nil
  def find_circle_by_id(id, preload_list \\ []) do
    Repo.get(Circle, id)
    |> Repo.preload(preload_list)
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

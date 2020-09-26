defmodule Akyuu.Music do
  alias Akyuu.Repo
  alias Akyuu.Music.{Album, Circle, Event, Track, Member}, warn: false

  @spec list_albums() :: Ecto.Schema.t() | [Ecto.Schema.t()] | nil
  @doc """
  Returns all the albums from the database without preloading anything.
  """
  def list_albums do
    Album
    |> Repo.all()
  end

  @spec list_albums([atom()]) :: Ecto.Schema.t() | [Ecto.Schema.t()] | nil
  @doc """
  Returns all the albums from the database and preloads the attributes specified
  in the preload_list.
  """
  def list_albums(preload_list) when is_list(preload_list) do
    Album
    |> Repo.all()
    |> Repo.preload(preload_list)
  end

  @spec list_albums_full() :: Ecto.Schema.t() | [Ecto.Schema.t()] | nil
  @doc """
  Returns all the albums from the database with all the attributes preloaded.
  This function is extremely expensive since it queries all the database, please
  use it sparingly.
  """
  def list_albums_full do
    Album
    |> Repo.all()
    |> Repo.preload(circle: [:members], event: [], track: [member: :circle])
  end

  def search_albums(name) do
    Album
    |> Album.search(name)
    |> Repo.all()
  end

  def search_circles(name) do
    Circle
    |> Circle.search(name)
    |> Repo.all()
  end
end

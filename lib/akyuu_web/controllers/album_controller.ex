defmodule AkyuuWeb.AlbumController do
  use AkyuuWeb, :controller

  alias Akyuu.Music
  alias Akyuu.Music.Album
  alias Akyuu.Repo

  # Takes /albums/:id
  def show(conn, %{"id" => id} = _params) do
    live_render(conn, AkyuuWeb.Album.AlbumLive, session: %{"album_id" => id})
  end

  def edit(conn, %{"id" => id}) do
    id = String.to_integer(id)

    case Music.find_album_by_id(id) do
      album when not is_nil(album) ->
        conn
        |> render("edit.html", album: album)

      nil ->
        conn
        |> put_flash(:error, "The requested album does not exist.")
        |> redirect(to: Routes.static_path(conn, "/"))
    end
  end

  def update(conn, %{"id" => id, "album" => album} = params) do
    found_album = Music.find_album_by_id(String.to_integer(id))
    changeset = Album.changeset(found_album, album)

    # Repo.update!(changeset)

    if album["cover_art"] do
      Album.CoverArt.store({album["cover_art"], found_album})
    end

    conn
    |> redirect(to: Routes.album_path(conn, :show, id))
  end

  def new(conn, _params) do
    changeset = Album.changeset(%Album{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    conn
  end
end

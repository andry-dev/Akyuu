defmodule AkyuuWeb.AlbumLive.New do
  @moduledoc false

  use Surface.LiveView

  import AkyuuWeb.AlbumView

  alias Akyuu.Music
  alias Akyuu.Music.Album
  alias AkyuuWeb.AlbumLive.FormComponent

  def mount(_params, _assigns, socket) do
    album = %Album{}

    changeset = Album.changeset(album)

    {:ok, assign(socket, album: album, changeset: changeset)}
  end

  def render(assigns) do
    ~H"""
    <FormComponent id="1" changeset={{ @changeset }} album={{ @album }} />
    """
  end
end

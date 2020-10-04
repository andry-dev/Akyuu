defmodule AkyuuWeb.AlbumController do
  use AkyuuWeb, :controller

  alias Akyuu.Music

  # Takes /albums/:id
  def show(conn, %{"id" => id} = _params) do
    id = String.to_integer(id)

    preload_list = [
      :circles,
      event_participations: [
        event: [
          :event
        ]
      ],
      tracks: [
        performed_by_members: [
          :roles,
          :member
        ]
      ]
    ]

    case Music.find_album_by_id(id, preload_list) do
      nil ->
        conn
        |> put_flash(:error, "The provided album does not exist!")
        |> redirect(to: Routes.static_path(conn, "/"))

      album ->
        conn
        |> render("album.html", album: album)
    end
  end
end

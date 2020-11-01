defmodule AkyuuWeb.AlbumLive.Show do
  @moduledoc false

  use AkyuuWeb, :live_view
  use AkyuuWeb.LiveViewPowHelper

  import AkyuuWeb.AlbumView

  alias Akyuu.Music
  alias Akyuu.Music.Album
  alias AkyuuWeb.AlbumLive.FormComponent
  alias AkyuuWeb.Components.DiscCard
  alias AkyuuWeb.Components.Empty
  alias AkyuuWeb.Components.EventCard
  alias AkyuuWeb.Router.Helpers, as: Routes

  def mount(%{"id" => id}, assigns, socket) do
    id = String.to_integer(id)

    case Music.find_album_by_id(id, :preload_all) do
      nil ->
        socket =
          socket
          |> put_flash(:error, "The requested album does not exist.")
          |> redirect(to: Routes.page_path(socket, :index))

        {:ok, socket}

      album when not is_nil(album) ->
        socket =
          socket
          |> assign(:album, album)
          |> assign(:album_changeset, Album.changeset(album, %{}))
          |> maybe_assign_current_user(assigns)

        {:ok, socket}
    end
  end

  def render("css", _assigns) do
    {:safe, "<link rel='stylesheet' src='/css/album.css'/>"}
  end

  def render(assigns) do
    ~H"""
    <div x-data="edit()">
      <button :if={{ allow_edits?(assigns) }} class="button" @click="enable()" type="button"><i class="fas fa-edit"></i> Edit</button>

      <button :if={{ allow_edits?(assigns) }} :on-click="delete-album" class="button button-danger" type="button"><i class="fas fa-trash-alt"></i> Delete</button>

      <FormComponent :if={{ allow_edits?(assigns) }} id={{ @album.id }} change="validate-edit" submit="submit-edit" changeset={{ @album_changeset }} album={{ @album }} />

      <div class="album-head">
        <div class="flex-image">
          <div class="image-container">
            <img class="album-cover-art" src="{{ get_cover_art(@album) }} "/>
          </div>

          <div class="album-summary image-content">
            <span class="album-title">{{ @album.title }}</span>
            <span class="album-label">{{ @album.label }}</span>
            <span :if={{ @album.romaji_title }} class="album-romaji-title">{{ @album.romaji_title }}</span>
            <span :if={{ @album.english_title }} class="album-english-title">{{ @album.english_title }}</span>
            <p>Produced by the following circles</p>
            <ul>
              <li :for={{ circle <- @album.circles }}>{{ display_circle(circle) }}</li>
            </ul>
            <p>Length: {{ calculate_album_length(@album) }}</p>

            <div :if={{ logged_in?(assigns) }} class="inline-row inline-little-spacing">
              <button type="button" class="button"><i class="fas fa-plus"></i> Add to wishlist</button>
              <button type="button" class="button"><i class="fas fa-shopping-cart"></i> Shop</button>
            </div>
          </div>
        </div>
      </div>

      <div class="album-info">
        <div class="tracks">
          <h2>Discs</h2>
          <Empty :for={{ disc <- @album.cds  }} >
            <DiscCard disc={{ disc }} />
          </Empty>
        </div>

        <div class="album-secondary-info">
          <div class="preview" :if={{ @album.xfd_url }}>
            <h2>Preview</h2>
            <audio :if={{ direct_url?(@album.xfd_url) }} controls src={{ @album.xfd_url }} />
            <iframe :if={{ youtube_url?(@album.xfd_url) }} src={{ @album.xfd_url }} scrolling="no" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

            <iframe :if={{ soundcloud_url?(@album.xfd_url) }} scrolling="no" frameborder="no" allow="autoplay" src={{ @album.xfd_url }}></iframe>
          </div>
          <div class="events">
            <h2>Events</h2>
            <Empty :for={{ edition <- @album.event_participations }}>
              <EventCard edition={{ edition }} />
            </Empty>
          </div>

          <div class="shops">
              <h2>Shops</h2>
          </div>
        </div>
      </div>
    </div>

    <script>
    function edit() {
      return {
        edit_mode: false,
        enable() {
          this.edit_mode = true
          document.querySelector("body").setAttribute("noscroll", true)
        },
        disable() {
          this.edit_mode = false
          document.querySelector("body").removeAttribute("noscroll")
        }
      }
    }
    </script>
    """
  end

  def handle_event("delete-album", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("validate-edit", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("submit-edit", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("submit-form", %{"album" => album}, socket) do
    case Music.update_album(socket.assigns.album.id, album, :preload_all) do
      {:error, :album_not_found} ->
        {:noreply, put_flash(socket, :error, "Can't edit album information")}

      {:error, changeset} ->
        socket
        |> assign(:album, album)
        |> assign(:album_changeset, changeset)

        {:noreply, socket}

      new_album ->
        socket =
          socket
          |> assign(:album, new_album)
          |> assign(:album_changeset, Album.changeset(new_album, %{}))

        {:noreply, socket}
    end
  end

  defp logged_in?(%{:current_user => user}) do
    user != nil
  end

  defp logged_in?(_) do
    false
  end

  defp allow_edits?(%{:current_user => user} = assigns) do
    if logged_in?(assigns) do
      true
    else
      false
    end
  end

  defp allow_edits?(_) do
    false
  end
end

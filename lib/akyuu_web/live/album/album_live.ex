defmodule AkyuuWeb.Album.AlbumLive.EditForm do
  @moduledoc false

  use Surface.LiveComponent

  alias Akyuu.Music
  alias AkyuuWeb.Components.CircleSearch
  alias AkyuuWeb.Components.Modal
  alias AkyuuWeb.Router.Helpers, as: Routes
  alias Surface.Components.Form
  alias Surface.Components.Form.Checkbox
  alias Surface.Components.Form.Field
  alias Surface.Components.Form.FileInput
  alias Surface.Components.Form.Inputs
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.NumberInput
  alias Surface.Components.Form.TextInput

  import AkyuuWeb.AlbumView

  prop(changeset, :map, required: true)
  prop(album, :map, required: true)

  def render(assigns) do
    ~H"""
    <Modal x_show="edit_mode" close_action="disable()">
      <template slot="header">
        <span><strong>Edit album information</strong></span>
        <div>
          <button type="submit" form="album-form">Save</button>
          <button type="button" @click="disable()">Cancel</button>
        </div>
      </template>

      <Form for={{ @changeset }} action={{ Routes.album_path(@socket, :update, @album.id) }} opts={{ multipart: true, id: "album-form", class: "modal-form" }}>

        <h2>General</h2>

        <div class="inline-row inline-medium-spacing">
          <div class="flex-image">
            <div class="image-content">
              <div class="inline-col inline-no-spacing">
              <Field name="title" class="form-entry">
                <Label>Album title</Label>
                <TextInput/>
              </Field>

              <Field name="romaji_title" class="form-entry">
                <Label>Album title (romaji)</Label>
                <TextInput/>
              </Field>

              <Field name="english_title" class="form-entry">
                <Label>Album title (English)</Label>
                <TextInput/>
              </Field>

              <Field name="label" class="form-entry">
                <Label>Album label</Label>
                <TextInput/>
              </Field>
              </div>
            </div>

            <div class="image-container">
              <Field name="cover_art" class="form-entry">

                <div class="image-upload">
                  <Label>
                    <span>Cover art</span>
                    <img class="album-cover-art" src="{{ get_cover_art(@album) }}"/>
                  </Label>
                  <FileInput/>
                </div>
              </Field>
            </div>
          </div>
        </div>

        <hr/>

        <h2>Circles</h2>

        <CircleSearch id="circle-search" pick="pick-circle" />

        <Inputs for={{ :circles }}>
          <Context get={{ Form, form: f }}>
            <Field name="id"><NumberInput opts={{ hidden: true}}/></Field>

            <Field name="name" class="form-entry">
              <Label>{{ f.data.name }}</Label>
              <TextInput opts={{ hidden: true }}/>
            </Field>
          </Context>
        </Inputs>

        <hr/>

        <h2>Discs</h2>

        <Inputs for={{ :cds }}>
            <div class="inline-row inline-little-spacing">
              <Field name="number" class="form-entry">
                <Label>CD number</Label>
                <NumberInput/>
              </Field>

              <Field name="title" class="form-entry">
                  <Label>CD title</Label>
                  <TextInput/>
              </Field>
            </div>

            <div class="inline-row inline-little-spacing">
              <Field name="romaji_title" class="form-entry">
                <Label>CD Romaji title</Label>
                <TextInput/>
              </Field>

              <Field name="english_title" class="form-entry">
                <Label>CD English title</Label>
                <TextInput/>
              </Field>
            </div>

            <Field name="hidden?" class="form-entry form-entry-inline">
              <Checkbox/>
              <Label>Is the CD hidden? </Label>
            </Field>

            <Inputs for={{ :tracks }} >
              <div class="inline-row inline-little-spacing">
                <Field name="number" class="form-entry">
                  <Label>Track number</Label>
                  <NumberInput/>
                </Field>

                <Field name="title" class="form-entry">
                  <Label>Track title</Label>
                  <TextInput/>
                </Field>
              </div>

              <div class="inline-row inline-little-spacing">
                <Field name="romaji_title" class="form-entry">
                  <Label>Track romaji title</Label>
                  <TextInput/>
                </Field>

                <Field name="english_title" class="form-entry">
                  <Label>Track english title</Label>
                  <TextInput/>
                </Field>
              </div>

              <Field name="length" class="form-entry">
                <Label>Track length</Label>
                <NumberInput/>
              </Field>

              <Field name="hidden?" class="form-entry form-entry-inline">
                <Checkbox/>
                <Label>Hidden track</Label>
              </Field>
            </Inputs>
        </Inputs>
      </Form>
    </Modal>
    """
  end

  def handle_event("pick-circle", %{"result" => circle_id}, socket) do
    new_circle = Music.find_circle_by_id(String.to_integer(circle_id))

    existing_circles =
      Map.get(socket.assigns.changeset.changes, :circles, socket.assigns.album.circles)
      |> Enum.concat([
        new_circle
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:circles, existing_circles)

    changeset =
      if changeset.changes != %{} and
           changeset.changes.circles do
        updated_circle_list =
          changeset.changes
          |> Map.get(:circles)
          |> Enum.uniq_by(fn x ->
            circle = Map.get(x, :data)
            circle.id
          end)

        new_changes = put_in(changeset.changes, [:circles], updated_circle_list)

        %Ecto.Changeset{changeset | changes: new_changes}
      else
        changeset
      end

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-track", _value, socket) do
    {:noreply, socket}
  end
end

defmodule AkyuuWeb.Album.AlbumLive do
  @moduledoc false

  use Surface.LiveView

  import AkyuuWeb.AlbumView

  alias Akyuu.Music
  alias Akyuu.Music.Album
  alias AkyuuWeb.Album.AlbumLive.EditForm
  alias AkyuuWeb.Components.DiscCard
  alias AkyuuWeb.Components.Empty
  alias AkyuuWeb.Components.EventCard
  alias AkyuuWeb.Router.Helpers, as: Routes

  def mount(_params, %{"album_id" => album_id}, socket) do
    id = String.to_integer(album_id)

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

        {:ok, socket}
    end
  end

  def update_action(socket, album) do
    Routes.album_path(socket, :update, album.id)
  end

  def render("css", _assigns) do
    {:safe, "<link rel='stylesheet' src='/css/album.css'/>"}
  end

  def render(assigns) do
    ~H"""
    <div x-data="edit()">
      <button class="edit" @click="enable()" type="button">Edit</button>

      <EditForm id={{ @album.id }} changeset={{ @album_changeset }} album={{ @album }} />


      <div class="album-head">
        <div class="flex-image">
          <div class="image-container">
            <img class="album-cover-art" src="{{ get_cover_art(@album) }} "/>
          </div>

          <div class="album-info image-content">
            <span class="album-title">{{ @album.title }}</span>
            <span class="album-label">{{ @album.label }}</span>
            <span :if={{ @album.romaji_title }} class="album-romaji-title">{{ @album.romaji_title }}</span>
            <span :if={{ @album.english_title }} class="album-english-title">{{ @album.english_title }}</span>

            <p>Produced by the following circles</p>
            <ul>
              <li :for={{ circle <- @album.circles }}>{{ display_circle(circle) }}</li>
            </ul>
            <p>Length: {{ calculate_album_length(@album) }}</p>
          </div>

        </div>
      </div>

      <div class="album-details">
        <div class="tracks">
          <h3>Tracks</h3>
          <Empty :for={{ disc <- @album.cds  }} >
            <DiscCard disc={{ disc }} />
          </Empty>
        </div>

        <div class="events">
          <h3>Events</h3>
          <Empty :for={{ edition <- @album.event_participations }}>
            <EventCard edition={{ edition }} />
          </Empty>
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
end

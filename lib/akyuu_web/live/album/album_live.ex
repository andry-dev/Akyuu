defmodule AkyuuWeb.Album.AlbumLive.EditForm do
  @moduledoc false

  use Surface.LiveComponent

  alias Akyuu.Music
  alias AkyuuWeb.Components.Card
  alias AkyuuWeb.Components.CircleSearch
  alias AkyuuWeb.Components.Empty
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
          <button class="button" type="submit" form="album-form">Save</button>
          <button class="button button-danger" type="button" @click="disable()">Cancel</button>
        </div>
      </template>

      <Form for={{ @changeset }} action={{ Routes.album_path(@socket, :update, @album.id) }} opts={{ multipart: true, id: "album-form", class: "modal-form height-100" }}>
        <div class="split-panel-nav" x-data="{ tabIndex: 0 }">
          <nav class="vert">
            <div @click="tabIndex = 0" class="nav-elem" x-bind:selected="tabIndex == 0">General</div>
            <div :for={{ cd <- Ecto.Changeset.get_field(@changeset, :cds) }}>
              <div @click="tabIndex = {{ cd.number }}" class="nav-elem" x-bind:selected="tabIndex == {{ cd.number }}">
                CD {{ cd.number }} <button class="button button-danger small-button " type="button" :on-click="remove-cd" phx-value-cd="{{ cd.number }}"><i class="fas fa-trash-alt"></i></button>
              </div>
            </div>

            <div class="nav-elem" :on-click="add-cd">Add CD</div>
          </nav>

          <div class="panel-content">
            <div x-show="tabIndex == 0">
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
                        <span>A label is an unique string that identifies an album.</span>
                        <TextInput/>
                      </Field>

                      <Field name="xfd_url" class="form-entry">
                        <Label>Crossfade url</Label>
                        <span>The crossfade of the album should contain either a link to Youtube embed (<em>youtube.com/embed</em>), a link to a SoundCloud embed (<em>w.soundcloud.com</em>) or a direct link to the audio file.</span>
                        <TextInput/>
                      </Field>
                    </div>
                  </div>

                  <div class="image-container">
                    <Field name="cover_art" class="form-entry">

                      <label>Cover art</label>
                      <span>Click on the image to upload a new cover art.</span>
                      <div class="image-upload">
                        <Label>
                          <img class="album-cover-art" src="{{ get_cover_art(@album) }}"/>
                        </Label>
                        <FileInput/>
                      </div>
                    </Field>
                  </div>
                </div>
              </div>

              <h2>Circles</h2>

              <p>Here you can search for circles and add them to the list of circles
              that collaborated to create this album.
              </p>

              <div class="form-entry">
                <Label>Search circles</Label>
                <CircleSearch id="circle-search" pick="pick-circle"/>
              </div>

              <Inputs for={{ :circles }}>
                <Context get={{ Form, form: f }}>
                  <Field name="id"><NumberInput opts={{ hidden: true}}/></Field>

                  <Field name="name" class="form-entry">
                    <Label>{{ f.data.name }}</Label>
                    <TextInput opts={{ hidden: true }}/>
                  </Field>
                </Context>
              </Inputs>
            </div>

            <Inputs for={{ :cds }}>
              <Context get={{ Form, form: cd_f }}>
                <div x-show="tabIndex == {{ cd_f.data.number }}" x-cloak>
                  <h2>CD {{ cd_f.data.number }}</h2>

                  <div class="inline-row inline-little-spacing">
                    <Field name="number" class="form-entry">
                      <Label>Number</Label>
                      <NumberInput/>
                    </Field>

                    <Field name="title" class="form-entry">
                        <Label>Title</Label>
                        <TextInput/>
                    </Field>
                  </div>

                  <div class="inline-row inline-little-spacing">
                    <Field name="romaji_title" class="form-entry">
                      <Label>Romaji title</Label>
                      <TextInput/>
                    </Field>

                    <Field name="english_title" class="form-entry">
                      <Label>English title</Label>
                      <TextInput/>
                    </Field>
                  </div>

                  <Field name="hidden?" class="form-entry form-entry-inline">
                    <Checkbox/>
                    <Label>Is the CD hidden? </Label>
                  </Field>

                  <button class="button" type="button" :on-click="add-track" phx-value-cd={{ cd_f.data.number }}>New track</button>
                  <Inputs for={{ :tracks }} >
                    <Card class="card-nested-1">
                      <template slot="summary">
                        <Context get={{ Form, form: f }}>
                          <span>Track {{ f.data.number }} - {{ f.data.title }}</span>
                        </Context>
                      </template>

                      <template slot="summary_end">
                        <Context get={{ Form, form: f }}>
                          <button class="button small-button button-danger" type="button" :on-click="remove-track" phx-value-track="{{ f.data.number }}" phx-value-cd="{{ cd_f.data.number }}"><i class="fas fa-trash-alt"></i></button>
                        </Context>
                      </template>


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
                    </Card>
                  </Inputs>
                </div>
              </Context>
            </Inputs>
          </div>
        </div>
      </Form>
    </Modal>
    """
  end

  def handle_event("pick-circle", %{"result" => circle_id}, socket) do
    new_circle = Music.find_circle_by_id(String.to_integer(circle_id))

    new_circles =
      Ecto.Changeset.get_field(socket.assigns.changeset, :circles)
      |> Enum.concat([new_circle])
      |> Enum.uniq_by(fn x -> x.id end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:circles, new_circles)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-track", %{"cd" => cd_num}, socket) do
    cd_num = String.to_integer(cd_num)

    cds = Ecto.Changeset.get_field(socket.assigns.changeset, :cds)

    tracks =
      cds
      |> Enum.flat_map(fn cd ->
        if cd.number == cd_num do
          cd.tracks
        else
          []
        end
      end)

    max_track_num =
      tracks
      |> Enum.max_by(fn t -> t.number end)
      |> Map.get(:number)

    new_tracks =
      tracks
      |> Enum.concat([
        %Music.Track{
          number: max_track_num + 1,
          performed_by_members: []
        }
      ])

    new_cds =
      cds
      |> Enum.map(fn cd ->
        if cd.number == cd_num do
          Ecto.Changeset.change(cd)
          |> Ecto.Changeset.put_assoc(:tracks, new_tracks)
        else
          cd
        end
      end)

    new_changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_change(:cds, new_cds)

    {:noreply, assign(socket, changeset: new_changeset)}
  end

  def handle_event("add-cd", _value, socket) do
    cds = Ecto.Changeset.get_field(socket.assigns.changeset, :cds)

    max_cd_num =
      cds
      |> Enum.max_by(fn cd -> cd.number end)
      |> Map.get(:number)

    cds =
      cds
      |> Enum.concat([
        %Music.CD{
          number: max_cd_num + 1,
          tracks: [
            %Music.Track{number: 1, performed_by_members: []}
          ]
        }
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cds, cds)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-cd", %{"cd" => cd_num}, socket) do
    cd_num = String.to_integer(cd_num)

    cds = Ecto.Changeset.get_field(socket.assigns.changeset, :cds)

    if length(cds) != 1 do
      cds =
        cds
        |> Enum.reject(fn x -> x.number == cd_num end)

      changeset =
        socket.assigns.changeset
        |> Ecto.Changeset.put_assoc(:cds, cds)

      {:noreply, assign(socket, changeset: changeset)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("remove-track", %{"track" => track_num, "cd" => cd_num}, socket) do
    cd_num = String.to_integer(cd_num)
    track_num = String.to_integer(track_num)

    cds = Ecto.Changeset.get_field(socket.assigns.changeset, :cds)

    cd =
      cds
      |> Enum.filter(fn cd -> cd.number == cd_num end)

    tracks =
      cd
      |> Enum.flat_map(fn cd ->
        cd.tracks
      end)

    if length(tracks) != 1 do
      tracks =
        tracks
        |> Enum.reject(fn t -> t.number == track_num end)

      new_cds =
        cds
        |> Enum.map(fn cd ->
          if cd.number == cd_num do
            Ecto.Changeset.change(cd)
            |> Ecto.Changeset.put_assoc(:tracks, tracks)
          else
            cd
          end
        end)

      changeset =
        socket.assigns.changeset
        |> Ecto.Changeset.put_assoc(:cds, new_cds)

      {:noreply, assign(socket, changeset: changeset)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("validate", _values, socket) do
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
      <button class="button" @click="enable()" type="button"><i class="fas fa-edit"></i>Edit</button>

      <EditForm id={{ @album.id }} changeset={{ @album_changeset }} album={{ @album }} />

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

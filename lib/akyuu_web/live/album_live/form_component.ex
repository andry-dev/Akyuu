defmodule AkyuuWeb.AlbumLive.FormComponent do
  @moduledoc false

  use Surface.LiveComponent

  alias Akyuu.Music
  alias AkyuuWeb.Components.Card
  alias AkyuuWeb.Components.CircleSearch
  alias AkyuuWeb.Components.Modal
  alias AkyuuWeb.Components.SortableList
  alias AkyuuWeb.Components.SortableListItem
  alias Surface.Components.Form
  alias Surface.Components.Form.Checkbox
  alias Surface.Components.Form.Field
  alias Surface.Components.Form.FileInput
  alias Surface.Components.Form.Inputs
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.NumberInput
  alias Surface.Components.Form.TextInput

  import AkyuuWeb.AlbumView
  # import AkyuuWeb.ErrorHelpers

  data(validated_changeset, :map, default: %Ecto.Changeset{})
  prop(changeset, :map, required: true)
  prop(album, :map, required: true)
  prop(action, :string, default: "#")
  prop(change, :event)
  prop(submit, :event)

  def mount(_params, _assigns, socket) do
    assigns = [
      validated_changeset: nil
    ]

    {:ok, assign(socket, assigns)}
  end

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

      <Form for={{ @changeset }} action={{ @action }} change="validate" submit={{ @submit }} opts={{ multipart: true, id: "album-form", class: "modal-form height-100" }}>
        <div class="split-panel-nav" x-data="{ tabIndex: 0 }">
          <nav class="vert">
            <div @click="tabIndex = 0" class="nav-elem" x-bind:selected="tabIndex == 0">General</div>
            <SortableList id="cd-list-select" sort="sort-cds" target="#album-form">
              <SortableListItem class="sortable-list-item" :for={{ cd <- Ecto.Changeset.get_field(@changeset, :cds) }} sortable_id={{ fetch_id(cd) }}>
                <div id={{ fetch_id(cd) }} @click="tabIndex = {{ fetch_id(cd) }}" class="nav-elem cursor-move" x-bind:selected="tabIndex == {{ fetch_id(cd) }}">
                  <img class="drag-indicator" src="/icons/drag_indicator.svg"/>
                  <span class="nav-elem-text">CD {{ cd.number }}</span>
                  <button class="button button-danger small-button" type="button" :on-click="remove-cd" phx-value-cd="{{ fetch_id(cd) }}"><i class="fas fa-trash-alt"></i></button>
                </div>
              </SortableListItem>
            </SortableList>

            <div class="nav-elem" :on-click="add-cd"><span><i class="fas fa-plus"></i> Add CD</span></div>
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
                        {{ error_tag @validated_changeset, :title }}
                      </Field>

                      <Field name="romaji_title" class="form-entry">
                        <Label>Album title (romaji)</Label>
                        <TextInput/>
                        {{ error_tag @validated_changeset, :romaji_title }}
                      </Field>

                      <Field name="english_title" class="form-entry">
                        <Label>Album title (English)</Label>
                        <TextInput/>
                        {{ error_tag @validated_changeset, :english_title }}
                      </Field>

                      <Field name="label" class="form-entry">
                        <Label>Album label</Label>
                        <span>A label is an unique string that identifies an album.</span>
                        <TextInput/>
                        {{ error_tag @validated_changeset, :label }}
                      </Field>

                      <Field name="xfd_url" class="form-entry">
                        <Label>Crossfade url</Label>
                        <span>The crossfade of the album should contain either a link to Youtube embed (<em>youtube.com/embed</em>), a link to a SoundCloud embed (<em>w.soundcloud.com</em>) or a direct link to the audio file.</span>
                        <TextInput/>
                        {{ error_tag @validated_changeset, :xfd_url }}
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
                <CircleSearch field={{ :circle_search }} id="circle-search" pick="pick-circle"/>
              </div>

              <Inputs for={{ :circles }}>
                <Context get={{ Form, form: f }}>
                  <Field name="id"><NumberInput opts={{ hidden: true}}/></Field>

                  <Field name="name" class="form-entry">
                    <Label>{{ f.data.name }} <button type="button" class="button small-button button-danger" :on-click="remove-circle" phx-value-circle={{ f.data.id }}><i class="fas fa-trash-alt"></i></button></Label>
                    <TextInput opts={{ hidden: true }}/>
                  </Field>
                </Context>
              </Inputs>
            </div>

            <Inputs for={{ :cds }}>
              <Context get={{ Form, form: cd_f }}>
              <Context put={{ cd_cs: filter_cd(@validated_changeset, cd_f.data.number) }}>
              <Context get={{ cd_cs: cd_cs }}>
                <div x-show="tabIndex == {{ fetch_id(cd_f.data) }}" x-cloak>
                  <h2>CD {{ cd_f.data.number }}</h2>

                  <Field name="number" class="form-entry">
                    <NumberInput opts={{ hidden: true }}/>
                    {{ error_tag cd_cs, :number }}
                  </Field>

                  <div class="inline-row inline-little-spacing full">
                    <Field name="title" class="form-entry">
                        <Label>Title</Label>
                        <TextInput/>
                    </Field>
                  </div>

                  <div class="inline-row inline-little-spacing full">
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

                  <h3>Tracks</h3>

                  <div class="inline-col inline-medium-spacing full">
                  <Inputs for={{ :tracks }}>
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

                      <div class="inline-row inline-little-spacing full">
                        <Field name="number" class="form-entry">
                          <Label>Track number</Label>
                          <NumberInput/>
                        </Field>

                        <Field name="title" class="form-entry">
                          <Label>Track title</Label>
                          <TextInput/>
                        </Field>
                      </div>

                      <div class="inline-row inline-little-spacing full">
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
                </div>
              </Context>
              </Context>
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
      |> Enum.concat([Music.Circle.changeset(new_circle)])
      |> Enum.uniq_by(fn x -> x.id end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:circles, new_circles)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-circle", %{"circle" => circle_id}, socket) do
    circle_id = String.to_integer(circle_id)

    circles = Ecto.Changeset.get_field(socket.assigns.changeset, :circles)

    if length(circles) > 1 do
      new_circles =
        circles
        |> Enum.reject(fn x -> x.id == circle_id end)

      changeset =
        socket.assigns.changeset
        |> Ecto.Changeset.put_assoc(:circles, new_circles)

      {:noreply, assign(socket, changeset: changeset)}
    else
      {:noreply, socket}
    end
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
        Music.Track.changeset(%Music.Track{
          number: max_track_num + 1,
          performed_by_members: []
        })
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
      |> Ecto.Changeset.put_assoc(:cds, new_cds)

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
        Music.CD.changeset(%Music.CD{
          tmp_id: gen_id(),
          number: max_cd_num + 1,
          tracks: [
            %Music.Track{number: 1, performed_by_members: []}
          ]
        })
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cds, cds)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-cd", %{"cd" => cd_id}, socket) do
    cd_id = String.to_integer(cd_id)

    cds = Ecto.Changeset.get_field(socket.assigns.changeset, :cds)

    if length(cds) > 1 do
      cds =
        cds
        |> Enum.reject(fn x -> x.id == cd_id or x.tmp_id == cd_id end)
        |> Enum.with_index(1)
        |> Enum.map(fn {cd, num} ->
          Map.put(cd, :number, num)
        end)

      changeset =
        socket.assigns.changeset
        |> Ecto.Changeset.put_assoc(:cds, cds)
        |> IO.inspect()

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

    if length(tracks) > 1 do
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

  def handle_event("sort-cds", %{"list" => list}, socket) do
    IO.inspect(list)

    cds =
      Ecto.Changeset.get_field(socket.assigns.changeset, :cds)
      |> Enum.map(fn x ->
        found_elem =
          Enum.find(list, fn %{"id" => cd_id} ->
            cd_id = String.to_integer(cd_id)
            x.id == cd_id or x.tmp_id == cd_id
          end)

        new_number = Map.get(found_elem, "sort_order") + 1

        Map.put(x, :number, new_number)
      end)
      |> Enum.sort_by(fn x -> x.number end, :asc)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:cds, cds)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"_target" => ["album", "circle_search"]}, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"album" => album}, socket) do
    changeset = Music.Album.changeset(%Music.Album{}, album)

    {:noreply, assign(socket, validated_changeset: changeset)}
  end

  defp filter_cd(nil, _), do: %Ecto.Changeset{}

  defp filter_cd(changeset, cd_num) do
    cs = Ecto.Changeset.get_change(changeset, :cds)

    if cs != nil do
      cs
      |> Enum.find(fn x ->
        number = Ecto.Changeset.get_field(x, :number)
        number == cd_num
      end)
    else
      changeset
    end
  end

  defp filter_track(nil, _), do: nil

  defp filter_track(changeset, track_num) do
    Ecto.Changeset.get_change(changeset, :tracks)
    |> Enum.flat_map(fn x ->
      if x.data.id == track_num do
        x
      end
    end)
  end

  defp error_tag(nil, _), do: ""

  defp error_tag(changeset, field) do
    Enum.map(Keyword.get_values(changeset.errors, field), fn {error, _} ->
      Phoenix.HTML.Tag.content_tag(:span, error, class: "help is-danger")
    end)
  end

  defp fetch_id(object) do
    if object.id do
      object.id
    else
      object.tmp_id
    end
  end

  defp gen_id() do
    :crypto.strong_rand_bytes(2)
    |> :crypto.bytes_to_integer()
  end
end

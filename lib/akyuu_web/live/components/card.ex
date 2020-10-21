defmodule AkyuuWeb.Components.Card do
  @moduledoc false

  use Surface.Component

  slot(default, required: true)

  slot(summary, required: true)

  slot(summary_end, required: false)

  prop(class, :css_class)

  prop(open, :boolean, default: true)

  def render(assigns) do
    ~H"""
    <details class="card {{ @class }}" open={{ @open }}>
      <summary class="card-header">
        <div class="inline-row inline-little-spacing">
          <slot name="summary"/>
        </div>

        <div class="card-header-end">
          <slot name="summary_end"/>
        </div>
      </summary>

      <div class="details-content">
        <slot />
      </div>
    </details>
    """
  end
end

defmodule AkyuuWeb.Components.TrackCard do
  @moduledoc false

  use Surface.Component

  alias AkyuuWeb.Components.Card

  import AkyuuWeb.AlbumView

  prop(track, :map, required: true)

  def render(assigns) do
    ~H"""
      <Card class="card-nested-1">
        <template slot="summary">
          <span class="track-no">{{ @track.number }}.</span>
          <span class="track-title">{{ @track.title }}</span>
          <span>(<span class="track-length">{{ calculate_track_length(@track) }}</span>)</span>
        </template>

        <template slot="summary_end">
          <span :if={{ instrumental?(@track) }} class="track-instrumental">(instrumental)</span>
        </template>

        <span :if={{ @track.romaji_title }} class="track-romaji-title">{{ @track.romaji_title }}</span>
        <span :if={{ @track.english_title }} class="track-english-title">{{ @track.english_title }}</span>

        <hr/>
        <span :for={{ member_assoc <- @track.performed_by_members }}>
          <span class="track-role">
          {{ display_roles(member_assoc.roles) }}:
          </span>
          {{ display_member(member_assoc.member) }}
        </span>
      </Card>
    """
  end
end

defmodule AkyuuWeb.Components.DiscCard do
  @moduledoc false

  use Surface.Component

  alias AkyuuWeb.Components.Card
  alias AkyuuWeb.Components.Empty
  alias AkyuuWeb.Components.TrackCard

  prop(disc, :map, required: true)

  def render(assigns) do
    ~H"""
    <Card>
      <template slot="summary">
        <span class="disc-no">Disc {{ @disc.number }}</span>
        <span>{{ length @disc.tracks }} tracks</span>
      </template>

      <Empty :for={{ track <- @disc.tracks }} >
        <TrackCard track={{ track }} />
      </Empty>
    </Card>
    """
  end
end

defmodule AkyuuWeb.Components.EventCard do
  @moduledoc false
  use Surface.Component

  alias AkyuuWeb.Components.Card

  prop(edition, :map, required: true)

  def render(assigns) do
    ~H"""
    <Card>
      <template slot="summary">
        <span class="event-no">[{{ Akyuu.Music.EventEdition.abbreviation_to_string(@edition.edition) }}]</span>
        <span class="event-name">{{ @edition.edition.event.name }} {{ @edition.edition.edition }}</span>
      </template>

      <span class="event-romaji-name">{{ @edition.edition.event.romaji_name }}</span>
      <span class="event-english-name">{{ @edition.edition.event.english_name }}</span>

      <hr/>

      <span>Price: <span class="event-price">{{ @edition.price_jpy }}円</span></span>
    </Card>
    """
  end
end

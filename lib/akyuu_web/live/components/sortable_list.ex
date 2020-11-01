defmodule AkyuuWeb.Components.SortableList do
  @moduledoc false

  use Surface.LiveComponent

  prop(sort, :string, required: true)
  prop(target, :string, required: true)

  def render(assigns) do
    ~H"""
    <div id={{ "list-" <> @id }} phx-hook="InitSortable" data-event-name={{ @sort }} data-target-id={{ @target }}>
      <slot/>
    </div>
    """
  end

  # def handle_event(event, values, socket) do
  #  IO.inspect(event)
  #  send(self(), {String.to_atom(socket.assigns.sort.name), values})

  #  {:noreply, socket}
  # end
end

defmodule AkyuuWeb.Components.SortableListItem do
  @moduledoc false

  use Surface.Component

  prop(sortable_id, :string, required: true)
  prop(class, :css_class)

  def render(assigns) do
    ~H"""
    <div class={{ @class }} data-sortable-id={{ @sortable_id }}>
      <slot/>
    </div>
    """
  end
end

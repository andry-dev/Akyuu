defmodule AkyuuWeb.Components.Search do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Surface.LiveComponent

      alias AkyuuWeb.Components.Empty
      alias Surface.Components.Form.TextInput

      prop(pick, :event, required: true)

      def render(var!(assigns)) do
        ~H"""
        <div>
          <TextInput class="search-bar" keydown="search" value={{ Map.get(assigns, :query, "") }} />
          <div :if={{ Map.get(assigns, :results, []) != [] }} class="search-results">
            <Empty :for={{ result <- Map.get(assigns, :results) }}>
              <div class="search-result" :on-click={{ @pick }} phx-value-result="{{ result.id }}">{{ display(result) }}</div>
            </Empty>
          </div>
        </div>
        """
      end
    end
  end
end

defmodule AkyuuWeb.Components.CircleSearch do
  @moduledoc false
  use AkyuuWeb.Components.Search

  alias Akyuu.Music

  def mount(_params, _assigns, socket) do
    assigns = [
      query: "",
      results: []
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("search", %{"value" => query}, socket) do
    results =
      case query do
        "" -> []
        _ -> Music.search_circles(query)
      end

    assigns = [
      query: query,
      results: results
    ]

    {:noreply, assign(socket, assigns)}
  end

  def display(circle) do
    circle.name <>
      if circle.romaji_name != nil do
        " (#{circle.romaji_name})"
      else
        ""
      end
  end
end

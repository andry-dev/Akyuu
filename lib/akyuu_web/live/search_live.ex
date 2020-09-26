defmodule AkyuuWeb.SearchLive do
  use AkyuuWeb, :live_view

  alias Akyuu.Accounts
  alias Akyuu.Music

  def render(assigns) do
    ~L"""
    <form class="search-form" phx-change="search">
      <input type="text" name="q" value="<%= @query %>" placeholder="Search..." autocomplete="off" class="search-bar" />

      <%= if @results != [] do %>
      <div style="position: relative">
        <div class="results-box">
          <%= if @results[:circles] != nil do %>
            <p class="results-category">Circles</p>
            <%= for circle <- @results[:circles] do %>
              <div class="search-result"><%= circle.name %> (<%= circle.romaji_name %>)</div>
            <% end %>
          <% end %>

          <%= if @results[:albums] != nil do %>
            <p class="results-category">Albums</p>
            <%= for album <- @results[:albums] do %>
              <div class="search-result"><%= album.title %> (<%= album.romaji_title %>)</div>
            <% end %>
          <% end %>

          <%= if @results[:tracks] != nil do %>
            <p class="results-category">Tracks</p>
            <%= for track <- @results[:tracks] do %>
              <div class="search-result"><%= track.title %></div>
            <% end %>
          <% end %>

          <%= if @results[:users] != nil do %>
            <p class="results-category">Users</p>
            <%= for user <- @results[:users] do %>
              <div class="search-result"><%= user.username %></div>
            <% end %>
          <% end %>
        </div>
      </div>
      <% end %>
    </form>
    """
  end

  def mount(_params, _assigns, socket) do
    assigns = [
      query: nil,
      results: []
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("search", %{"q" => query}, socket) do
    results = [
      users: search_users(query),
      albums: search_albums(query),
      circles: search_circles(query)
    ]

    assigns = [
      results: filter_list(results)
    ]

    IO.inspect(assigns)

    {:noreply, assign(socket, assigns)}
  end

  defp search_users(query) do
    case query do
      "" -> []
      _ -> Accounts.search_user(query)
    end
  end

  defp search_albums(query) do
    case query do
      "" -> []
      _ -> Music.search_albums(query)
    end
  end

  defp search_circles(query) do
    case query do
      "" -> []
      _ -> Music.search_circles(query)
    end
  end

  defp filter_list(results) do
    Enum.reject(results, fn {_k, v} -> v == [] end)
  end
end

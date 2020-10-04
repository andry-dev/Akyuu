defmodule AkyuuWeb.SearchLive do
  @moduledoc """
  LiveView for the global search at the top of the page.

  This module searches everything in the database and displays it 
  """
  use AkyuuWeb, :live_view

  import AkyuuWeb.View.Helpers

  alias Akyuu.Accounts
  alias Akyuu.Music

  def render(assigns) do
    ~L"""
    <form class="search-form" phx-change="search">
      <div class="search-bar-div">
        <img id="search-icon" src="/icons/search.svg"/>
        <input type="text" name="q" value="<%= @query %>" autocomplete="off" class="search-bar" />
      </div>

      <%= if @results != [] do %>
      <div style="position: relative">
        <div class="results-box">
          <%= if @results[:circles] != nil do %>
            <p class="results-category">Circles</p>
            <%= for circle <- @results[:circles] do %>
              <div class="search-result"><%= display_circle(circle) %></div>
            <% end %>
          <% end %>

          <%= if @results[:albums] != nil do %>
            <p class="results-category">Albums</p>
            <%= for album <- @results[:albums] do %>
              <div class="search-result">
                <a href="/album/<%= album.id %>"><%= album.title %></a>
                <%= if album.romaji_title do %>
                  (<span class="album-romaji-title"><%= album.romaji_title %></span>)
                <% end %>
              </div>
            <% end %>
          <% end %>

          <%= if @results[:members] != nil do %>
            <p class="results-category">Members</p>
            <%= for member <- @results[:members] do %>
            <div class="search-result">
              <%= display_member(member) %>
            </div>
            <% end %>
          <% end %>

          <%= if @results[:tracks] != nil do %>
            <p class="results-category">Tracks</p>
            <%= for track <- @results[:tracks] do %>
            <div class="search-result">
              <%= display_track(track) %>
            </div>
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

  defp display_circle(circle) do
    circle.name <>
      if circle.romaji_name != nil do
        " (" <> circle.romaji_name <> ")"
      else
        ""
      end
  end

  defp display_track(track) do
    track.title <>
      if track.romaji_title != nil do
        " (" <> track.romaji_title <> ")"
      else
        ""
      end
  end

  defp display_album(album) do
    album.title <>
      if album.romaji_title != nil do
        " (" <> album.romaji_title <> ")"
      else
        ""
      end
  end

  defp display_member(member) do
    member.name <>
      if member.romaji_name != nil do
        " (" <> member.romaji_name <> ")"
      else
        ""
      end
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
      circles: search_circles(query),
      members: search_members(query),
      tracks: search_tracks(query)
    ]

    assigns = [
      results: filter_list(results)
    ]

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

  defp search_tracks(query) do
    case query do
      "" -> []
      _ -> Music.search_tracks(query)
    end
  end

  defp search_members(query) do
    case query do
      "" -> []
      _ -> Music.search_members(query)
    end
  end

  defp filter_list(results) do
    Enum.reject(results, fn {_k, v} -> v == [] end)
  end
end

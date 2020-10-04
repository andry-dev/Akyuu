defmodule AkyuuWeb.AlbumView do
  use AkyuuWeb, :view

  import AkyuuWeb.View.Helpers

  alias Akyuu.Music.EventEdition

  def display_title(album) do
    content_tag :h1, class: "album-title" do
      album.title
    end
  end

  @spec display_roles(roles :: [%Akyuu.Music.Role{}]) :: String.t()
  def display_roles(roles) do
    roles
    |> Enum.map(fn x -> x.name end)
    |> Enum.join(", ")
  end

  def display_circle(circle) do
    [
      content_tag :span, class: "circle-name" do
        link(circle.name, to: "/circle")
      end
    ]
    |> add_if_possible(
      circle.romaji_name,
      [
        " (",
        content_tag(:span, circle.romaji_name, class: "circle-romaji-name"),
        ")"
      ]
    )
  end

  @spec display_member(member :: %Akyuu.Music.Member{}) :: Tag.t()
  def display_member(member) do
    [
      content_tag :span, class: "track-member" do
        link(member.name, to: "/member/")
      end
    ]
    |> add_if_possible(
      member.romaji_name,
      [
        " (",
        content_tag(:span, "#{member.romaji_name}", class: "track-member-romaji"),
        ")"
      ]
    )
  end

  def instrumental?(track) do
    track.performed_by_members
    |> Enum.flat_map(fn x -> x.roles end)
    |> Enum.map(fn x -> x.name end)
    |> Enum.all?(fn name -> name != "vocals" end)
  end

  defp format_time(time) do
    minute =
      time.minute
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    second =
      time.second
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    if time.hour == 0 do
      "#{minute}:#{second}"
    else
      hour =
        time.hour
        |> Integer.to_string()
        |> String.pad_leading(2, "0")

      "#{hour}:#{minute}:#{second}"
    end
  end

  def calculate_track_length(track) do
    format_time(Time.add(~T[00:00:00], track.length))
  end

  def calculate_album_length(album) do
    total_seconds =
      album.tracks
      |> Enum.map(fn x -> x.length end)
      |> Enum.reduce(0, fn x, acc -> x + acc end)

    format_time(Time.add(~T[00:00:00], total_seconds))
  end
end

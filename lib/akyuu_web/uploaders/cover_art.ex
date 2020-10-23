defmodule Akyuu.Music.Album.CoverArt do
  @moduledoc """
  A Waffle module for storing the cover art for an album.
  """

  use Waffle.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @acl :public_read

  @versions [:original]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  def transform(:original, _) do
    {:convert, "-format png", :png}
  end

  def transform(:thumb, _) do
    {:convert, "-format png", :png}
  end

  # Override the persisted filenames:
  def filename(_version, _) do
    "art"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    Path.join(:code.priv_dir(:akyuu), "static/uploads/album/cover_arts/#{scope.id}")
  end

  @doc """
  Returns the URL of the image relative to the webroot of the project.
  """
  def pretty_url(file) do
    storage_path = Path.join(:code.priv_dir(:akyuu), "/static")

    tmp =
      url(file)
      |> Path.relative_to(storage_path)

    Path.join("/", tmp)
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "/images/cover_arts/default.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end

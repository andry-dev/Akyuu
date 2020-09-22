defmodule Akyuu.Music do
  alias Akyuu.Repo
  alias Akyuu.Music

  def list_albums do
    Repo.all(Music.Album)
  end
end

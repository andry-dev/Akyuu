defmodule Akyuu.Accounts do
  @moduledoc """
  Module implementing CRUD operations for the users and their roles and
  wishlist in the database.
  """
  import Ecto.Query, warn: false
  alias Akyuu.Repo
  alias Akyuu.Accounts.{User, UserWishlist}

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user(integer) :: Repo
  def get_user(id) do
    User
    |> Repo.get(id)
  end

  @spec list_users() :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def list_users do
    User
    |> Repo.all()
  end

  @spec search_user(String.t()) :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def search_user(name) do
    User
    |> User.search(name)
    |> Repo.all()
  end

  @spec search_user(String.t(), [atom()]) :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def search_user(name, preload_list) do
    User
    |> User.search(name)
    |> Repo.all()
    |> Repo.preload(preload_list)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @spec add_to_wishlist(User, Album) :: Ecto.Schema.t()
  def add_to_wishlist(user, album) do
    %UserWishlist{user_id: user.id, album_id: album.id}
    |> Repo.insert!()
  end

  @spec remove_from_wishlist(User, Album) :: Ecto.Schema.t()
  def remove_from_wishlist(user, album) do
    %UserWishlist{user_id: user.id, album_id: album.id}
    |> Repo.delete!()
  end

  @spec view_wishlist(User) :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def view_wishlist(user) do
    query =
      from a in Akyuu.Music.Album,
        join: w in UserWishlist,
        on: w.album_id == a.id and w.user_id == ^user.id

    Repo.all(query)
  end
end

defmodule Akyuu.Accounts.UserWishlist do
  @moduledoc """
  A wishlist is a set of albums that a user wants to buy.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "users_wishlists" do
    belongs_to :user, Akyuu.Accounts.User, primary_key: true
    belongs_to :album, Akyuu.Music.Album, primary_key: true

    timestamps()
  end

  def changelist(users_wishlist, attrs) do
    users_wishlist
    |> cast(attrs, [:user_id, :album_id])
  end
end

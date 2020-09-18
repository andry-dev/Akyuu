defmodule Akyuu.Accounts.UserWishlist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users_wishlist" do
    belongs_to :user, Akyuu.User, primary_key: true
    belongs_to :album, Akyuu.Album, primary_key: true

    timestamps()
  end

  def changelist(users_wishlist, attrs) do
    users_wishlist
    |> cast(attrs, [:user_id, :album_id])
  end
end

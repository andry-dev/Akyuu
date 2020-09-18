defmodule Akyuu.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AkyuuCrypto.PasswordField

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, PasswordField

    many_to_many :wanted_album, Akyuu.Album, join_through: Akyuu.UserWishlist

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_hash])
    |> validate_required([:username, :email, :password_hash])
    |> unique_constraint([:username])
    |> unique_constraint([:email])
  end
end

defmodule Akyuu.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    user_id_field: :username,
    password_hash_methods: {
      &Argon2.hash_pwd_salt/1,
      &Argon2.verify_pass/2
    }

  use Pow.Extension.Ecto.Schema

  # extensions: []

  import Ecto.Changeset

  # alias AkyuuCrypto.PasswordField
  alias Akyuu.Accounts.User

  schema "users" do
    field :username, :string

    many_to_many :wanted_album, Akyuu.Music.Album,
      join_through: Akyuu.Accounts.UserWishlist,
      on_replace: :delete

    pow_user_fields()

    timestamps()
  end

  # @required_fields ~w(username email wanted_album password_hash)a

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> pow_user_id_field_changeset(attrs)
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> unique_constraint([:username])
  end

  @doc false
  def changeset_update_wishlist(%User{} = user, albums) do
    user
    |> cast(%{}, [:wanted_album])
    |> put_assoc(:wanted_album, albums)
  end
end

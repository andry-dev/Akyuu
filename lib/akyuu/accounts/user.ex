defmodule Akyuu.Accounts.User do
  use Ecto.Schema

  use Pow.Ecto.Schema,
    user_id_field: :username,
    password_hash_methods: {
      &Argon2.hash_pwd_salt/1,
      &Argon2.verify_pass/2
    }

  use Pow.Extension.Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Accounts.User

  @type t :: %__MODULE__{
          username: String.t(),
          public?: boolean(),
          indexed?: boolean(),
          wanted_albums: [Akyuu.Music.Album.t()]
        }

  schema "users" do
    field :username, :string
    field :public?, :boolean, source: :is_public, default: false
    field :indexed?, :boolean, source: :is_indexed, default: false

    many_to_many :wanted_albums, Akyuu.Music.Album,
      join_through: Akyuu.Accounts.UserWishlist,
      on_replace: :delete

    pow_user_fields()

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> pow_user_id_field_changeset(attrs)
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:username, :public?, :indexed?])
    |> unique_constraint([:username])
    |> validate_length(:username, max: 255)
  end

  @doc false
  def changeset_update_wishlist(%User{} = user, albums) do
    user
    |> cast(%{}, [:wanted_album])
    |> put_assoc(:wanted_albums, albums)
  end

  @spec search(User, String.t()) :: %Ecto.Query{}
  def search(schema, username) do
    from user in schema,
      where: [public?: true, indexed?: true],
      where: ilike(user.username, ^"%#{username}%")
  end
end

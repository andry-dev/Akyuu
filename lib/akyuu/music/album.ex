defmodule Akyuu.Music.Album do
  @moduledoc """
  An album is a collection of CDs released by a circle at an event.
  The same album can be released more than once in any edition of any event.

  The wishlist of an user is composed of these albums.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Music.{Album, AlbumCD, CD}
  alias Akyuu.Repo

  @typedoc """
  Type that represents an album.

  ## Attributes

  * `:label`: An unique identifier for the album.
     It is generally formed by a 4-letter alphabetic code that identifies the
     circle and a number that identifies the album.
  * `:title`: The _original_ title of the album.
     That is, if the name is Japanese then this attribute contains Japanese text.
  * `:romaji_title`: The translitterated title of the album in romaji.
     If the original title _is not_ in Japanese then this attribute should be nil.
  * `:english_title`: An english translation of the original title, it it exists.
  * `:cds`: The CDs that make up the album.
  * `:events`: The events where the album was released.
  * `:circles`: The circles behind the album.
  * `:wanted_by_users`: Which users wants the album.
  * `:xfd_url`: The URL of the crossfade/preview.
  * `:cover_art_path`: The path of the cover art in the server.
  """
  @type t :: %__MODULE__{
          label: String.t(),
          title: String.t(),
          romaji_title: String.t(),
          english_title: String.t(),
          cds: [Akyuu.Music.CD.t()],
          events: [Akyuu.Music.EventEdition.t()],
          circles: [Akyuu.Music.Circle.t()],
          wanted_by_users: [Akyuu.Accounts.User.t()],
          xfd_url: String.t(),
          cover_art_path: String.t()
        }

  schema "albums" do
    field :label, :string
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :xfd_url, :string
    field :cover_art_path, :string

    many_to_many :cds, Akyuu.Music.CD,
      join_through: Akyuu.Music.AlbumCD,
      on_replace: :delete

    has_many :event_participations, Akyuu.Music.AlbumEvent
    has_many :events, through: [:event_participations, :event]

    many_to_many :circles, Akyuu.Music.Circle,
      join_through: Akyuu.Music.CircleAlbum,
      on_replace: :delete

    many_to_many :wanted_by_users, Akyuu.Accounts.User,
      join_through: Akyuu.Accounts.UserWishlist,
      on_replace: :delete

    timestamps()
  end

  @required_fields ~w(label title romaji_title english_title xfd_url cover_art_path)a

  @doc false
  def changeset(album, attrs \\ %{}) do
    album
    |> cast(attrs, @required_fields)
    |> validate_required([:label, :title])
    |> unique_constraint([:label])
  end

  @doc false
  def search(schema, name) do
    to_search = "%#{name}%"

    from album in schema,
      where: ilike(album.title, ^to_search),
      or_where: ilike(album.romaji_title, ^to_search),
      or_where: ilike(album.english_title, ^to_search),
      or_where: ilike(album.label, ^to_search)
  end

  @doc """
  Adds a CD to an album.

  Returns either the association between the two or an error with the changeset.
  """
  @spec add_cd(album :: t(), cd :: CD.t()) ::
          Ecto.Schema.t() | {:error, Ecto.Changeset.t()}
  def add_cd(%Album{} = album, %CD{} = cd) do
    res =
      %AlbumCD{}
      |> AlbumCD.changeset(%{album_id: album.id, cd_id: cd.id})
      |> Repo.insert()

    case res do
      {:ok, _} -> album
      error_type -> error_type
    end
  end
end

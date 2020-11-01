defmodule Akyuu.Music.Circle do
  @moduledoc """
  A circle is a group of people ("members" of the circle) that release one or
  more albums.

  This is different from the common notion of a "group" or "band", because
  "members" can be in multiple circles at the same time. This happens because a
  circle is more like an umbrella term for a project that some people want to
  move forward.

  The members in a circle can collaborate with other circles to produce a joint
  album or to help creating some tracks for an album. For example, Merami is the
  vocalist of the circle "Cosmopolitan" but she's also part of the circle
  "Diao ye Zong" also as a vocalist. The same happens for other vocalists
  (Ranko from "BUTAOTOME", IZNA from "Touhou Jihen", nayuta from "7yuta", etc...)
  and other roles (arrangement, illustration, lyrics, etc...).

  You can think of a circle as a loosely-coupled group of people that
  create _and publish_ albums.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Music.{Album, CircleAlbum, CircleMember, Member}
  alias Akyuu.Repo

  @typedoc """
  Type that represents a circle.

  ## Attributes

  - `:name`: The _original_ name of the circle.
    That is, if the original name is Japanese then the value here should be in
    Japanese.
  - `:romaji_name`: The romaji translitteration of the name of the circle.
    If the original name is not in Japanese then this attribute should be nil.
  - `:english_name`: The english translation of the name if it exists.
  - `:members`: The members that are fulltime
  """
  @type t :: %__MODULE__{
          name: String.t(),
          romaji_name: String.t(),
          english_name: String.t(),
          members: [Akyuu.Music.Member.t()]
        }

  schema "circles" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    has_many :participating_members, Akyuu.Music.CircleMember
    has_many :members, through: [:participating_members, :member]

    timestamps()
  end

  @doc false
  def changeset(circle, attrs \\ %{}) do
    circle
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  @doc false
  def search(schema, name) do
    to_search = "%#{name}%"

    from circle in schema,
      where: ilike(circle.name, ^to_search),
      or_where: ilike(circle.romaji_name, ^to_search),
      or_where: ilike(circle.english_name, ^to_search)
  end

  @doc """
  Adds an album to a circle.

  This function returns the same circle.
  """
  @spec add_album(circle :: t(), album :: Album.t()) :: t()
  def add_album(circle, album) do
    %CircleAlbum{}
    |> CircleAlbum.changeset(%{circle_id: circle.id, album_id: album.id})
    |> Repo.insert()

    circle
  end

  @spec add_member(circle :: t(), member :: String.t(), opts :: Keyword.t()) :: t()
  def add_member(circle, member, opts) when is_binary(member) do
    found_member = Repo.get_by(Member, name: member)

    add_member(circle, found_member, opts)
  end

  @doc """
  Adds a member to a circle.

  ## Parameters
  - circle: The circle to which a member should be added.
  - member: The member to add.
  - opts: A keyword list of options with the following entries:
    - roles: A list of roles (as strings) that the member fullfills in the circle.

  ## Overloads
  When the overload with `member :: String.t()` is used then the function will
  try to find the member by the name. It will try to match the `member` parameter
  with just the `name` attribute in `Akyuu.Music.Member`.

  ## Examples

      # Suppose we have:
      # diao_ye_zong = %Akyuu.Music.Circle{ ... }
      # merami = %Akyuu.Music.Member{ ... }
      iex> add_member(diao_ye_zong, merami, roles: ["vocals"])
      %Akyuu.Music.Circle{ ... }
  """
  @spec add_member(circle :: t(), member :: Member.t(), opts :: [roles: [String.t()]]) :: t()
  def add_member(circle, member, opts) do
    found_roles =
      Repo.all(
        from r in Akyuu.Music.Role,
          where: r.name in ^opts[:roles]
      )

    changeset_attrs =
      opts
      |> Enum.into(%{})
      |> Map.put(:circle_id, circle.id)
      |> Map.put(:member_id, member.id)

    {:ok, membership} =
      %CircleMember{}
      |> CircleMember.changeset(changeset_attrs)
      |> Repo.insert()

    membership
    |> Repo.preload(:roles)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, found_roles)
    |> Repo.update()

    circle
  end
end

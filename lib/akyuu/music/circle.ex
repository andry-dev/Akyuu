defmodule Akyuu.Music.Circle do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Music.{Circle, Album, Member, CircleAlbum, CircleMember}
  alias Akyuu.Repo

  schema "circles" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    many_to_many :members, Akyuu.Music.Member, join_through: Akyuu.Music.CircleMember

    timestamps()
  end

  @doc false
  def changeset(circle, attrs) do
    circle
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  def search(schema, name) do
    to_search = "%#{name}%"

    from circle in schema,
      where: ilike(circle.name, ^to_search),
      or_where: ilike(circle.romaji_name, ^to_search),
      or_where: ilike(circle.english_name, ^to_search)
  end

  def add_album(%Circle{} = circle, %Album{} = album, _opts \\ []) do
    %CircleAlbum{}
    |> CircleAlbum.changeset(%{circle_id: circle.id, album_id: album.id})
    |> Repo.insert()

    circle
  end

  def add_member(%Circle{} = circle, %Member{} = member, opts) do
    found_roles =
      Repo.all(
        from r in Akyuu.Music.Role,
          where: r.name in ^opts[:roles]
      )

    changeset_attrs =
      Map.from_struct(
        Kernel.struct(
          %CircleMember{
            circle_id: circle.id,
            member_id: member.id
          },
          opts
        )
      )

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

  def add_member(%Circle{} = circle, member, opts) when is_binary(member) do
    found_member = Repo.get_by(Member, name: member)

    add_member(circle, found_member, opts)
  end
end

defmodule Akyuu.Music.Member do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Akyuu.Repo
  alias Akyuu.Music.{Role, Track, TrackMember}

  @moduledoc """
  A member is any person that is part of one or more circles.

  A member may help create tracks ("perform") for circles they are not part of.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          romaji_name: String.t(),
          english_name: String.t(),
          circles: [Akyuu.Music.Circle.t()],
          tracks: [Akyuu.Music.Track.t()]
        }

  schema "members" do
    field :name, :string
    field :romaji_name, :string
    field :english_name, :string

    many_to_many :circles, Akyuu.Music.Circle, join_through: Akyuu.Music.CircleMember
    many_to_many :tracks, Akyuu.Music.Track, join_through: Akyuu.Music.TrackMember

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name, :romaji_name, :english_name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  @doc false
  def search(schema, name) do
    to_search = "%#{name}%"

    from member in schema,
      where: ilike(member.name, ^to_search),
      or_where: ilike(member.romaji_name, ^to_search),
      or_where: ilike(member.english_name, ^to_search)
  end

  @doc """
  Adds a performance to a track.
  That is, adds a relationship between a member of any circle and a track in any
  album.

  ## Parameters
  - member: The member that performs in a track.
  - track: The track where the member performs.
  - opts: A keyword list of options with there keys:
    - roles: A list of strings that specify which role the member has in the
      creation of the track.
  """
  @spec add_performance(member :: t(), track :: Track.t(), opts :: Keyword.t()) :: t()
  def add_performance(member, track, opts \\ []) do
    found_roles =
      from r in Role,
        where: r.name in ^opts[:roles]

    found_roles = Repo.all(found_roles)

    changeset_attrs =
      Map.from_struct(
        Kernel.struct(
          %TrackMember{
            track_id: track.id,
            member_id: member.id
          },
          opts
        )
      )

    {:ok, performance} =
      %TrackMember{}
      |> TrackMember.changeset(changeset_attrs)
      |> Repo.insert()

    performance
    |> Repo.preload(:roles)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, found_roles)
    |> Repo.update()

    member
  end
end

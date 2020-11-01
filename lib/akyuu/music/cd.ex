defmodule Akyuu.Music.CD do
  @moduledoc """
  A CD is a collection of tracks present in an album.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Akyuu.Repo
  alias Akyuu.Music.{CD, Track, TrackCD}

  @type t :: %__MODULE__{
          number: non_neg_integer(),
          title: String.t(),
          romaji_title: String.t(),
          english_title: String.t(),
          hidden?: boolean(),
          albums: [Akyuu.Music.Album.t()],
          tracks: [Akyuu.Music.Track.t()]
        }

  schema "cds" do
    field :number, :integer
    field :title, :string
    field :romaji_title, :string
    field :english_title, :string
    field :hidden?, :boolean, source: :is_hidden, default: false

    field :tmp_id, :integer, virtual: true

    many_to_many :albums, Akyuu.Music.Album, join_through: Akyuu.Music.AlbumCD

    many_to_many :tracks, Akyuu.Music.Track,
      join_through: Akyuu.Music.TrackCD,
      on_replace: :delete

    many_to_many :genres, Akyuu.Music.Genre, join_through: Akyuu.Music.GenreCD

    timestamps()
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [:number, :title, :romaji_title, :english_title, :hidden?])
    |> validate_required(:number)
    |> validate_number(:number, greater_than: 0)
    |> cast_assoc(:tracks, with: &Track.changeset/2)
  end

  @doc """
  Adds a track to a CD.

  Returns either the association between the two or an error with the changeset.
  """
  @spec add_track(cd :: t(), track :: Track.t()) ::
          Ecto.Schema.t() | {:error, Ecto.Changeset.t()}
  def add_track(%CD{} = cd, %Track{} = track) do
    res =
      %TrackCD{}
      |> TrackCD.changeset(%{cd_id: cd.id, track_id: track.id})
      |> Repo.insert()

    case res do
      {:ok, _} -> cd
      error_type -> error_type
    end
  end
end

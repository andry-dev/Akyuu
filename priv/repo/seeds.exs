# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Akyuu.Repo.insert!(%Akyuu.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Akyuu.Repo
alias Akyuu.Music

Repo.insert!(%Music.Event{
  name: "コミックマーケット",
  romaji_name: "komikku maketto",
  abbreviation: "comiket",
  edition: 97,
  start_date: ~D[2019-12-28],
  end_date: ~D[2019-12-31]
})

Repo.insert!(%Music.Member{
  name: "RD-Sounds"
})

Repo.insert!(%Music.Member{
  name: "めらみぽっぷ",
  romaji_name: "Meramipop"
})

Repo.insert!(%Music.Member{
  name: "nayuta"
})

Repo.insert!(%Music.Circle{
  name: "凋叶棕",
  romaji_name: "diao ye zong"
})

Repo.insert!(%Music.CircleMember{
  circle_id: 1,
  member_id: 1,
  role: "arrangement"
})

Repo.insert!(%Music.CircleMember{
  circle_id: 1,
  member_id: 2,
  role: "vocals"
})

Repo.insert!(%Music.CircleMember{
  circle_id: 1,
  member_id: 3,
  role: "vocals"
})

Repo.insert!(%Music.Album{
  label: "RDWL-0030",
  title: "彁"
})

Repo.insert!(%Music.Album{
  label: "RDWL-0029",
  title: "奏",
  romaji_title: "kanade",
  english_title: "performance"
})

Repo.insert!(%Music.Track{
  cd_number: 1,
  track_number: 1,
  title: "ALL EVIL MISCHIEF",
  hidden?: false
})

Repo.insert!(%Music.AlbumTrack{
  album_id: 1,
  track_id: 1
})

Repo.insert!(%Music.TrackMember{
  role: "arrangement",
  track_id: 1,
  member_id: 1
})

Repo.insert!(%Music.CircleAlbum{
  album_id: 1,
  circle_id: 1
})

Repo.insert!(%Music.CircleAlbum{
  album_id: 2,
  circle_id: 1
})

Repo.insert!(%Music.AlbumEvent{
  event_id: 1,
  album_id: 1,
  price_jpy: 1000
})

alias Akyuu.Repo
alias Akyuu.Music

import Ecto.Query

rd_sounds = Repo.get_by!(Music.Member, name: "RD-Sounds")
nayuta = Repo.get_by!(Music.Member, name: "nayuta")
merami = Repo.get_by!(Music.Member, name: "めらみぽっぷ")
miko = Repo.get_by!(Music.Member, name: "miko")
kushi = Repo.get_by!(Music.Member, name: "Φ串Φ")

{:ok, 彁} =
  Music.create_album(%{
    label: "RDWL-0030",
    title: "彁"
  })

{:ok, all_evil_mischief} =
  Music.create_track(%{
    number: 1,
    title: "ALL EVIL MISCHIEF",
    length: Music.to_seconds(min: 4, sec: 30),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, all_evil_mischief, roles: ["arrangement"])

{:ok, hocus_pocus} =
  Music.create_track(%{
    number: 2,
    title: "ホーカス・ポーカス",
    romaji_title: "hocus pocus",
    length: Music.to_seconds(min: 5, sec: 18),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, hocus_pocus, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(merami, hocus_pocus, roles: ["vocals"])

{:ok, marks_of_sin} =
  Music.create_track(%{
    number: 3,
    title: "Marks of Sin",
    length: Music.to_seconds(min: 5, sec: 31),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, marks_of_sin, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(miko, marks_of_sin, roles: ["vocals"])

{:ok, trill_moonshine} =
  Music.create_track(%{
    number: 4,
    title: "trill_Moonshine",
    length: Music.to_seconds(min: 3, sec: 44),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, trill_moonshine, roles: ["arrangement"])

{:ok, shoujo_monogatari} =
  Music.create_track(%{
    number: 5,
    title: "幻想少女物語",
    romaji_title: "gensou shoujo monogatari",
    length: Music.to_seconds(min: 5, sec: 48),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, shoujo_monogatari, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(merami, shoujo_monogatari, roles: ["vocals"])

{:ok, dipp} =
  Music.create_track(%{
    number: 6,
    title: "Dolls into Pitiful Pretenders",
    length: Music.to_seconds(min: 6, sec: 39),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, dipp, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(merami, dipp, roles: ["vocals"])

{:ok, metamorph} =
  Music.create_track(%{
    number: 7,
    title: "little_Metamorphoses",
    length: Music.to_seconds(min: 4, sec: 41),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, metamorph, roles: ["arrangement"])

{:ok, gensou_hoshigami} =
  Music.create_track(%{
    number: 8,
    title: "幻想星神信仰",
    romaji_title: "gensou hoshigami shinkou",
    length: Music.to_seconds(min: 5, sec: 44),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, gensou_hoshigami, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(kushi, gensou_hoshigami, roles: ["vocals"])

{:ok, nostalgic_road} =
  Music.create_track(%{
    number: 9,
    title: "懐かしき道",
    romaji_title: "natsukashiki michi",
    length: Music.to_seconds(min: 4, sec: 11),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, nostalgic_road, roles: ["arrangement"])

{:ok, kusuburunanika} =
  Music.create_track(%{
    number: 10,
    title: "くすぶるなにか",
    romaji_title: "kusuburu nanika",
    length: Music.to_seconds(min: 7, sec: 18),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, kusuburunanika, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(nayuta, kusuburunanika, roles: ["vocals"])

{:ok, last_track} =
  Music.create_track(%{
    number: 11,
    title: "／彁",
    length: Music.to_seconds(min: 7, sec: 22),
    hidden?: false
  })

Music.Member.add_performance(rd_sounds, last_track, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(merami, last_track, roles: ["vocals"])

{:ok, cd1} =
  Music.create_cd(%{
    number: 1,
  })

cd1
|> Music.CD.add_track(all_evil_mischief)
|> Music.CD.add_track(hocus_pocus)
|> Music.CD.add_track(marks_of_sin)
|> Music.CD.add_track(trill_moonshine)
|> Music.CD.add_track(shoujo_monogatari)
|> Music.CD.add_track(dipp)
|> Music.CD.add_track(metamorph)
|> Music.CD.add_track(gensou_hoshigami)
|> Music.CD.add_track(nostalgic_road)
|> Music.CD.add_track(kusuburunanika)
|> Music.CD.add_track(last_track)

彁
|> Music.Album.add_cd(cd1)

Music.Event.find_event(:comiket, 97)
|> Music.EventEdition.add_album(彁, price_jpy: 1000)

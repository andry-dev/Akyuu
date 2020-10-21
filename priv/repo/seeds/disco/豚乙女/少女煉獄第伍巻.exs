alias Akyuu.Repo
alias Akyuu.Music

import Ecto.Query

ranko = Repo.get_by!(Music.Member, name: "ランコ")
comp = Repo.get_by!(Music.Member, name: "コンプ")
paprika = Repo.get_by!(Music.Member, name: "パプリカ")

{:ok, 少女煉獄第伍巻} =
  Music.create_album(%{
    title: "少女煉獄 第伍巻",
    romaji_title: "Shoujo Rengoku Daigokan",
    english_title: "Purgatory Girls 5",
    xfd_url: "https://www.youtube.com/embed/5hNhHeNv6WA"
  })

{:ok, utopia} =
  Music.create_track(%{
    number: 1,
    title: "偶像ユートピア",
    length: Music.to_seconds(min: 2, sec: 17)
  })

Music.Member.add_performance(ranko, utopia, roles: ["vocals", "lyrics"])
Music.Member.add_performance(comp, utopia, roles: ["arrangement"])

{:ok, kireina_niji} =
  Music.create_track(%{
    number: 2,
    title: "奇麗な虹",
    romaji_title: "kireina niji",
    length: Music.to_seconds(min: 3, sec: 18)
  })

Music.Member.add_performance(ranko, kireina_niji, roles: ["vocals", "lyrics"])
Music.Member.add_performance(comp, kireina_niji, roles: ["arrangement"])

{:ok, ashita_mo} =
  Music.create_track(%{
    number: 3,
    title: "明日も晴れますように",
    romaji_title: "ashita mo haremasu you ni",
    length: Music.to_seconds(min: 3, sec: 31)
  })

Music.Member.add_performance(ranko, ashita_mo, roles: ["vocals", "lyrics"])
Music.Member.add_performance(comp, ashita_mo, roles: ["arrangement"])
Music.Member.add_performance(paprika, ashita_mo, roles: ["arrangement"])

{:ok, rokubun} =
  Music.create_track(%{
    number: 4,
    title: "六分の一",
    romaji_title: "roku-bun'no ichi",
    length: Music.to_seconds(min: 2, sec: 57)
  })

Music.Member.add_performance(ranko, rokubun, roles: ["vocals"])
Music.Member.add_performance(comp, rokubun, roles: ["arrangement", "lyrics"])

{:ok, mizu} =
  Music.create_track(%{
    number: 5,
    title: "水は流れ河となってゆく",
    romaji_title: "mizu wa nagare kawa to natte yuku",
    length: Music.to_seconds(min: 4, sec: 12)
  })

Music.Member.add_performance(ranko, mizu, roles: ["vocals"])
Music.Member.add_performance(comp, mizu, roles: ["arrangement", "lyrics"])
Music.Member.add_performance(paprika, mizu, roles: ["arrangement"])

{:ok, shikaban} =
  Music.create_track(%{
    number: 6,
    title: "私家版百鬼夜行絵巻",
    romaji_title: "shikaban hyakkiyakou emaki",
    length: Music.to_seconds(min: 3, sec: 49)
  })

Music.Member.add_performance(ranko, shikaban, roles: ["vocals", "lyrics"])
Music.Member.add_performance(comp, shikaban, roles: ["arrangement"])
Music.Member.add_performance(paprika, shikaban, roles: ["arrangement"])

{:ok, ai} =
  Music.create_track(%{
    number: 7,
    title: "アイ",
    romaji_title: "ai",
    length: Music.to_seconds(min: 2, sec: 41)
  })

Music.Member.add_performance(ranko, ai, roles: ["vocals", "lyrics"])
Music.Member.add_performance(comp, ai, roles: ["arrangement"])

{:ok, seika} =
  Music.create_track(%{
    number: 8,
    title: "生花-seika-",
    romaji_title: "seika",
    length: Music.to_seconds(min: 2, sec: 39)
  })

Music.Member.add_performance(ranko, seika, roles: ["vocals"])
Music.Member.add_performance(comp, seika, roles: ["arrangement", "lyrics"])

{:ok, cd1} =
  Music.create_cd(%{
    number: 1
  })

cd1
|> Music.CD.add_track(utopia)
|> Music.CD.add_track(kireina_niji)
|> Music.CD.add_track(ashita_mo)
|> Music.CD.add_track(rokubun)
|> Music.CD.add_track(mizu)
|> Music.CD.add_track(shikaban)
|> Music.CD.add_track(ai)
|> Music.CD.add_track(seika)

少女煉獄第伍巻
|> Music.Album.add_cd(cd1)

Music.Event.find_event(:comiket, 98)
|> IO.inspect()
|> Music.EventEdition.add_album(少女煉獄第伍巻, price_jpy: 1000)

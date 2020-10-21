alias Akyuu.Repo
alias Akyuu.Music

{:ok, butaotome} =
  Music.create_circle(%{
    name: "豚乙女",
    romaji_name: "BUTAOTOME"
  })

Code.require_file("豚乙女/少女煉獄第伍巻.exs", __DIR__)

butaotome
|> Music.Circle.add_member("ランコ", roles: ["vocals", "lyrics"])
|> Music.Circle.add_member("コンプ", roles: ["arrangement", "lyrics"])
|> Music.Circle.add_member("パプリカ", roles: ["arrangement"])
|> Music.Circle.add_member("ランコの姉", roles: ["illustration"])
|> Music.Circle.add_album(Repo.get_by!(Music.Album, title: "少女煉獄 第伍巻"))

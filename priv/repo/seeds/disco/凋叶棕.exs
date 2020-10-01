alias Akyuu.Repo
alias Akyuu.Music

{:ok, diao_ye_zong} =
  Music.create_circle(%{
    name: "凋叶棕",
    romaji_name: "diao ye zong",
    english_name: "withered leaf"
  })

Code.require_file("凋叶棕/彁.exs", __DIR__)

diao_ye_zong
|> Music.Circle.add_member("RD-Sounds", roles: ["arrangement", "lyrics"])
|> Music.Circle.add_member("めらみぽっぷ", roles: ["vocals"])
|> Music.Circle.add_member("nayuta", roles: ["vocals"])
|> Music.Circle.add_album(Repo.get_by!(Music.Album, title: "彁"))

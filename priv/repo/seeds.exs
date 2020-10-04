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

Repo.insert!(%Music.Role{
  name: "arrangement"
})

Repo.insert!(%Music.Role{
  name: "vocals"
})

Repo.insert!(%Music.Role{
  name: "lyrics"
})

Repo.insert!(%Music.Role{
  name: "illustration"
})

Code.require_file("seeds/members.exs", __DIR__)
Code.require_file("seeds/events.exs", __DIR__)

Code.require_file("seeds/disco.exs", __DIR__)

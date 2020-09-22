defmodule Akyuu.Accounts do
  import Ecto.Query, warn: false
  alias Akyuu.Repo
  alias Akyuu.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def list_users do
    Repo.all(User)
  end

  def search_user(name) do
    query =
      from user in User,
        select: [:username],
        where: like(user.username, ^"%#{name}%")

    Repo.all(query)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end

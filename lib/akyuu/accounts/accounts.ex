defmodule Akyuu.Accounts do
  import Ecto.Query, warn: false
  alias Akyuu.Repo
  alias Akyuu.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user(integer) :: Repo
  def get_user(id) do
    User
    |> Repo.get(id)
  end

  @spec list_users() :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def list_users do
    User
    |> Repo.all()
  end

  @spec search_user(String.t()) :: nil | [Ecto.Schema.t()] | Ecto.Schema.t()
  def search_user(name) do
    User
    |> User.search(name)
    |> Repo.all()
  end

  def search_user(name, preload_list) do
    User
    |> User.search(name)
    |> Repo.all()
    |> Repo.preload(preload_list)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end

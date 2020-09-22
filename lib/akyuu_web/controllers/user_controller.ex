defmodule AkyuuWeb.UserController do
  use AkyuuWeb, :controller

  alias Akyuu.Accounts
  alias Akyuu.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  # Takes an /users/:id
  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      found_user when not(is_nil(found_user)) ->
        render(conn, "user.html", user: found_user)
      _ ->
        conn
        |> put_flash(:error, "User ##{id} does not exist.")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Error!")
        |> render("new.html", changeset: changeset)
    end
  end
end

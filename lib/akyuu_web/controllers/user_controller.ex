defmodule AkyuuWeb.UserController do
  use AkyuuWeb, :controller

  alias Akyuu.Accounts
  alias Akyuu.Accounts.User

  plug :check_auth

  # Takes an /users/:id
  def show(conn, _params) do
    render(conn, "user.html")
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

  # Checks whether the user can access a profile or not.
  # If the profile is public, it should be accessible to anyone.
  # If the profile is private, it should be accessible only to its user.
  defp check_auth(conn, _opts) do
    user = conn.assigns.current_user
    id = conn.params |> Map.get("id") |> String.to_integer()

    case Accounts.get_user(id) do
      found_user when not is_nil(found_user) ->
        cond do
          found_user.public? or
              (!is_nil(user) and user.id == id) ->
            conn
            |> assign(:user, found_user)

          true ->
            invalid_auth(conn)
        end

      _ ->
        invalid_auth(conn)
    end
  end

  defp invalid_auth(conn) do
    conn
    |> put_flash(:error, "This profile is either private or it doesn't exist.")
    |> redirect(to: Routes.static_path(conn, "/"))
  end
end

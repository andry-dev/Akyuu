defmodule AkyuuWeb.UserLive do
  use AkyuuWeb, :live_view
  alias Akyuu.Accounts

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    {:ok, assign(socket, users: users, query: "")}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    users = search(query)
    {:noreply, assign(socket, users: users)}
  end

  defp search(query) do
    Accounts.search_user(query)
  end
end

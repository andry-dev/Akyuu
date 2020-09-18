defmodule AkyuuWeb.PageController do
  use AkyuuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

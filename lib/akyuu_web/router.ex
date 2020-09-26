defmodule AkyuuWeb.Router do
  use AkyuuWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {AkyuuWeb.LayoutView, :root}
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through :browser

    get "/users/edit", RegistrationController, :edit
    get "/users/new", RegistrationController, :new
    post "/users", RegistrationController, :create
    patch "/users", RegistrationController, :update
    put "/users", RegistrationController, :update
    delete "/users", RegistrationController, :delete

    get "/session/new", SessionController, :new
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", AkyuuWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/users/:id", UserController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", AkyuuWeb do
    pipe_through :api
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AkyuuWeb.Telemetry
    end
  end
end

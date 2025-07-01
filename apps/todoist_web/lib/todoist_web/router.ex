defmodule TodoistWeb.Router do
  use TodoistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoistWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoistWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/projects/new", ProjectLive, :new

    live "/:project_name/todos", TodoLive.Index, :index
    live "/:project_name/todos/new", TodoLive.Index, :new
    live "/:project_name/todos/:id/edit", TodoLive.Index, :edit

    live "/:project_name/todos/:id", TodoLive.Show, :show
    live "/:project_name/todos/:id/show/edit", TodoLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoistWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:todoist_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodoistWeb.Telemetry
    end
  end
end

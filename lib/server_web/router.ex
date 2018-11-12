defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :site do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {ServerWeb.LayoutView, :site}
  end

  pipeline :app do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ServerWeb.AuthenticatedUsersOnlyPlug, repo: Server.Repo
    plug :put_layout, {ServerWeb.LayoutView, :app}
  end

  pipeline :admin do
    plug BasicAuth, use_config: {:server, :basicAuthConfig}
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {ServerWeb.LayoutView, :admin}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServerWeb do
    pipe_through :site # Use the default browser stack

    get "/", PageController, :index
    get "/signup", PageController, :signup
    get "/login", PageController, :login_form
    post "/login", PageController, :login
    post "/signup", PageController, :signup_submit
    get "/auth/verify/:token", PageController, :signup_verify
  end

  scope "/play", ServerWeb do
    pipe_through :app
    get "/", GameController, :index
  end

  scope "/admin", ServerWeb do
    pipe_through :admin
    get "/", AdminController, :index
    resources "/users", UserController

  end

  # Other scopes may use custom stacks.
  # scope "/api", ServerWeb do
  #   pipe_through :api
  # end
end

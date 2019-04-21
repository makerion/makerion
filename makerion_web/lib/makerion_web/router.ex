defmodule MakerionWeb.Router do
  use MakerionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MakerionWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/firmware", FirmwareController, only: [:index, :create]
    resources "/print_files", PrintFileController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  scope "/api", MakerionWeb do
    pipe_through :api
    resources "/print_files", PrintFileController, only: [:new, :create]
  end
end

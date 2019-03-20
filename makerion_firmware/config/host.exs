use Mix.Config

config :makerion, ecto_repos: [Makerion.Repo]

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("../host-files/repo.sqlite3")

# Configure the main viewport for the Scenic application
config :makerion_kiosk, :viewport, %{
  name: :main_viewport,
  size: {800, 480},
  default_scene: {MakerionKiosk.Scene.SysInfo, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "makerion_kiosk"]
    }
  ]
}

config :makerion_web, MakerionWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false

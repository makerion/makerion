use Mix.Config

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
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "./assets/node_modules/parcel-bundler/bin/cli.js",
      "watch",
      "./assets/js/app.js",
      "--out-dir",
      "priv/static/js"
    ]
  ]

# Watch static and templates for browser reloading.
config :makerion_web, MakerionWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/makerion_web/views/.*(ex)$},
      ~r{lib/makerion_web/templates/.*(eex)$}
    ]
  ]

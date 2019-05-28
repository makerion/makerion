use Mix.Config

config :shoehorn,
  init: [:nerves_runtime, :makerion_init, :nerves_network, :nerves_firmware_ssh],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

config :nerves_network,
  regulatory_domain: "US"

config :makerion, ecto_repos: [Makerion.Repo]

config :makerion,
  print_file_path: "/root/print-files",
  printer_driver: Moddity.Driver

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("/root/repo.sqlite3")

config :picam, camera: Picam.Camera

config :makerion_updater,
  project: "makerion/makerion",
  runtime: Nerves.Runtime,
  version_metadata: Nerves.Runtime.KV,
  firmware_path: Path.join("/root", "firmware")

config :makerion_web, MakerionWeb.Endpoint,
  url: [host: "localhost"],
  http: [
    port: 80,
    protocol_options: [idle_timeout: :infinity]
  ],
  secret_key_base: "pYHbGO6Ir2A43i44U3VippGeoxu/wG1FjZKOX1bYvKzswsWROrSTDiFBhEoHFgrr",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: MakerionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MakerionWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false,
  check_origin: false,
  live_view: [
    signing_salt: "vGv59K4MSRCM34UPhifRphZTURII7lfO"
  ]

config :makerion_firmware,
  nerves_network: Nerves.Network

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :tzdata, :data_dir, "/root"

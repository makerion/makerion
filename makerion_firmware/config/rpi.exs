use Mix.Config

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :makerion_init],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

config :nerves_network,
  regulatory_domain: "US"

config :makerion, ecto_repos: [Makerion.Repo]

config :makerion,
  print_file_path: "/root/print-files",
  printer_driver: Moddity.Driver

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("/root/repo.sqlite3")

config :makerion_updater,
  project: "makerion/makerion",
  runtime: Nerves.Runtime,
  version_metadata: Nerves.Runtime.KV,
  firmware_path: Path.join("/root", "firmware")

config :makerion_web, MakerionWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
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

if File.exists?("rpi3.secret.exs") do
  import_config "rpi3.secret.exs"
end
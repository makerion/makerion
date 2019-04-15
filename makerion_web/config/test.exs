use Mix.Config

config :hound,
  driver: "chrome_driver",
  browser: "chrome_headless"

config :makerion_web, sql_sandbox: true

config :makerion_web, MakerionWeb.Endpoint,
  http: [port: 4001],
  check_origin: false,
  server: true

config :logger, level: :warn

use Mix.Config

config :makerion_web, MakerionWeb.Endpoint,
  http: [port: 4001],
  server: true

config :logger, level: :warn

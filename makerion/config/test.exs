use Mix.Config

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("#{File.cwd!}/../test.sqlite3"),
  pool: Ecto.Adapters.SQL.Sandbox

config :makerion, printer_backend: Moddity.Backend.Simulator

config :picam, camera: Picam.FakeCamera

config :logger, level: :warn

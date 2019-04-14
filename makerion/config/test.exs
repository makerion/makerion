use Mix.Config

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("#{File.cwd!}/../test.sqlite3"),
  pool: Ecto.Adapters.SQL.Sandbox

config :makerion, printer_driver: Moddity.FakeDriver

config :logger, level: :warn

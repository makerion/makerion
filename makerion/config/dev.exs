# Since configuration is shared in umbrella projects, this file
# should only configure the :makerion application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :makerion, Makerion.Repo,
  adapter: Sqlite.Ecto2,
  database: Path.expand("../host-files/repo.sqlite3")

# Since configuration is shared in umbrella projects, this file
# should only configure the :makerion application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :makerion, printer_driver: Moddity.FakeDriver

config :makerion, ecto_repos: [Makerion.Repo]

import_config "#{Mix.env()}.exs"

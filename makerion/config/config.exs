# Since configuration is shared in umbrella projects, this file
# should only configure the :makerion application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :makerion,
  print_file_path: Path.join([File.cwd!, "..", "host-files", "print-files"]),
  printer_backend: Moddity.Backend.Simulator

config :makerion, ecto_repos: [Makerion.Repo]

import_config "#{Mix.env()}.exs"

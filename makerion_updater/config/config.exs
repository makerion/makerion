# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :makerion_updater,
  project: "makerion/makerion"

import_config "#{Mix.target()}.exs"

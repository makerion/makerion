# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :makerion_web, MakerionWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "pYHbGO6Ir2A43i44U3VippGeoxu/wG1FjZKOX1bYvKzswsWROrSTDiFBhEoHFgrr",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: MakerionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MakerionWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :phoenix, :json_library, Jason

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

import_config "#{Mix.target()}.exs"

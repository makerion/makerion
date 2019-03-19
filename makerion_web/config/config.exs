# Since configuration is shared in umbrella projects, this file
# should only configure the :makerion_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

import_config "#{File.cwd!}/../makerion/config/config.exs"

# General application configuration
config :makerion_web,
  generators: [context_app: :makerion]

# Configures the endpoint
config :makerion_web, MakerionWeb.Endpoint,
  live_view: [
    signing_salt: "vGv59K4MSRCM34UPhifRphZTURII7lfO"
  ],
  url: [host: "localhost"],
  secret_key_base: "pYHbGO6Ir2A43i44U3VippGeoxu/wG1FjZKOX1bYvKzswsWROrSTDiFBhEoHFgrr",
  render_errors: [view: MakerionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MakerionWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix, :template_engines, leex: Phoenix.LiveView.Engine

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

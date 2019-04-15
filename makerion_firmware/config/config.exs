use Mix.Config

config :phoenix, :json_library, Jason
config :phoenix, :template_engines, leex: Phoenix.LiveView.Engine

import_config "#{Mix.target()}.exs"

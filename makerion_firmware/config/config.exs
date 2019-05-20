use Mix.Config

config :phoenix, :json_library, Jason
config :phoenix, :template_engines, leex: Phoenix.LiveView.Engine

if Mix.target() != :host do
  import_config "device.exs"
end
import_config "#{Mix.target()}.exs"

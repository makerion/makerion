# Since configuration is shared in umbrella projects, this file
# should only configure the :makerion_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :makerion, printer_driver: Moddity.FakeDriver

config :hound, driver: "chrome_driver"# , browser: "chrome_headless"

config :makerion_web, sql_sandbox: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :makerion_web, MakerionWeb.Endpoint,
  http: [port: 4001],
  server: true

use Mix.Config

config :makerion_updater,
  version_metadata: Nerves.Runtime.KV,
  runtime: Nerves.Runtime,
  firmware_path: Path.join("/root", "firmware")

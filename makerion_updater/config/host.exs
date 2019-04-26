use Mix.Config

config :makerion_updater,
  version_metadata: MakerionUpdater.KV,
  runtime: MakerionUpdater.HostRuntime,
  firmware_path: Path.expand("../host-files")

use Mix.Config

# only start the kiosk on rpi3

config :makerion_kiosk,
  nerves_networkinterface: Nerves.NetworkInterface

config :makerion_kiosk, :viewport, %{
  name: :main_viewport,
  default_scene: {MakerionKiosk.Scene.SysInfo, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Nerves.Rpi
    },
    %{
      module: Scenic.Driver.Nerves.Touch,
      opts: [
        device: "FT5406 memory based driver",
        calibration: {{1, 0, 0}, {1, 0, 0}}
      ]
    }
  ]
}

if File.exists?("rpi3.secret.exs") do
  import_config "rpi3.secret.exs"
end

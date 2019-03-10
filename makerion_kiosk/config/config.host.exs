use Mix.Config

# Configure the main viewport for the Scenic application
config :makerion_kiosk, :viewport, %{
  name: :main_viewport,
  size: {800, 480},
  default_scene: {MakerionKiosk.Scene.SysInfo, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "makerion_kiosk"]
    }
  ]
}

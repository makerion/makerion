defmodule MakerionKiosk.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :makerion_kiosk,
      version: "0.1.0",
      elixir: "~> 1.8",
      target: @target,
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MakerionKiosk, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:makerion, path: "../makerion"},

      {:scenic, "~> 0.9"},
      {:scenic_driver_glfw, "~> 0.9", targets: :host},
      {:scenic_sensor, "~> 0.7"},
      {:scenic_driver_nerves_rpi, "~> 0.9", targets: [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a]},
      {:scenic_driver_nerves_touch, "~> 0.9", targets: [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a]}
    ]
  end
end

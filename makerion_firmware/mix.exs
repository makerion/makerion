defmodule MakerionFirmware.MixProject do
  use Mix.Project

  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :bbb, :x86_64]

  def project do
    [
      app: :makerion_firmware,
      version: "0.1.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.5"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MakerionFirmware.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:makerion, path: "../makerion"},
      {:makerion_kiosk, path: "../makerion_kiosk"},
      {:makerion_web, path: "../makerion_web"},

      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_network, "~> 0.5", targets: @all_targets},
      {:yaml_elixir, "~> 2.0"},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.6", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.6", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, path: "../../nerves_system_rpi3", runtime: false, targets: :rpi3},
      # {:nerves_system_rpi3a, path: "../../nerves_system_rpi3a", runtime: false, targets: :rpi3a},
      {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
      {:nerves_system_x86_64, "~> 1.6", runtime: false, targets: :x86_64},
    ]
  end
end

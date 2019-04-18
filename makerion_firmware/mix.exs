defmodule MakerionFirmware.MixProject do
  use Mix.Project

  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :bbb, :x86_64]

  def project do
    [
      aliases: [loadconfig: [&bootstrap/1]],
      app: :makerion_firmware,
      archives: [nerves_bootstrap: "~> 1.5"],
      build_embedded: true,
      dialyzer: [
        plt_add_apps: ~w(ex_unit mix)a,
        plt_add_deps: :transitive,
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: "../.dialyzer-ignore.exs"
      ],
      deps: deps(),
      elixir: "~> 1.8",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:makerion, path: "../makerion"},
      {:makerion_kiosk, path: "../makerion_kiosk"},
      {:makerion_web, path: "../makerion_web"},

      # Dependencies for all targets
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:nerves, "~> 1.4", runtime: false},
      {:ring_logger, "~> 0.6"},
      {:shoehorn, "~> 0.4"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_network, "~> 0.5", targets: @all_targets},
      {:yaml_elixir, "~> 2.0"},

      # Dependencies for specific targets
      {:makerion_system_rpi0, "1.0.0", github: "makerion/makerion_system_rpi0", runtime: false, targets: :rpi0},
      {:makerion_system_rpi3, "1.0.0", github: "makerion/makerion_system_rpi3", runtime: false, targets: :rpi3},
    ]
  end
end

defmodule MakerionFirmware.MixProject do
  use Mix.Project

  @all_targets [:rpi, :rpi3]
  @version Path.join([__DIR__, "..", "VERSION"])
           |> File.read!()
           |> String.trim()


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
      version: @version
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
      {:makerion_kiosk, path: "../makerion_kiosk", targets: [:host, :rpi3]},
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
      {:makerion_init, path: "../makerion_init", targets: @all_targets},
      {:nerves_time, "~> 0.2", targets: @all_targets},
      {:nerves_firmware_ssh, "~> 0.3", targets: @all_targets},

      # Dependencies for specific targets
      {:makerion_system_rpi, "1.0.0", github: "makerion/makerion_system_rpi", runtime: false, targets: :rpi},
      {:makerion_system_rpi3, "1.0.0", github: "makerion/makerion_system_rpi3", runtime: false, targets: :rpi3},
    ]
  end
end

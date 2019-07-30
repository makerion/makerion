defmodule MakerionKiosk.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"
  @version Path.join([__DIR__, "..", "VERSION"])
           |> File.read!()
           |> String.trim()


  def project do
    [
      app: :makerion_kiosk,
      build_embedded: true,
      deps: deps(),
      dialyzer: [
        plt_add_apps: ~w(ex_unit mix)a,
        plt_add_deps: :transitive,
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: "../.dialyzer-ignore.exs"
      ],
      elixir: "~> 1.9",
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
      target: @target,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MakerionKiosk, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # internal deps
      {:makerion, path: "../makerion"},
      {:makerion_updater, path: "../makerion_updater"},

      # project deps
      {:scenic, "~> 0.9"},
      {:scenic_driver_glfw, "~> 0.9", targets: :host},
      {:scenic_sensor, "~> 0.7"},
      {:scenic_driver_nerves_rpi, "~> 0.9", targets: [:rpi3]},
      {:scenic_driver_nerves_touch, "~> 0.9", targets: [:rpi3]},

      # test/CI deps
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end

defmodule MakerionKiosk.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :makerion_kiosk,
      build_embedded: true,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: ~w(ex_unit mix)a,
        ignore_warnings: "../.dialyzer-ignore.exs"
      ],
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
      target: @target,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
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
      {:makerion, path: "../makerion"},

      {:scenic, "~> 0.9"},
      {:scenic_driver_glfw, "~> 0.9", targets: :host},
      {:scenic_sensor, "~> 0.7"},
      {:scenic_driver_nerves_rpi, "~> 0.9", targets: [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a]},
      {:scenic_driver_nerves_touch, "~> 0.9", targets: [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a]}
    ]
  end
end

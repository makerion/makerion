defmodule MakerionUpdater.MixProject do
  use Mix.Project

  @all_targets [:rpi0, :rpi3]
  @version Path.join([__DIR__, "..", "VERSION"])
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: :makerion_updater,
      deps: deps(),
      dialyzer: [
        plt_add_apps: ~w(ex_unit mix)a,
        plt_add_deps: :transitive,
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
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
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.0"},
      {:nerves_runtime, "~> 0.6", targets: @all_targets},

      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end
end

defmodule Makerion.MixProject do
  use Mix.Project

  @version Path.join([__DIR__, "..", "VERSION"])
           |> File.read!()
           |> String.trim()

  def project do
    [
      aliases: aliases(),
      app: :makerion,
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
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Makerion.Application, []},
      extra_applications: [:logger, :runtime_tools, :sqlite_ecto2, :ecto]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # internal deps
      {:makerion_camera, path: "../makerion_camera"},

      # project deps
      {:moddity, github: "makerion/moddity", branch: "master"},

      # test/CI deps
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.11", only: :test},
      {:sqlite_ecto2, "~> 2.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end

defmodule MakerionInit.MixProject do
  use Mix.Project

  @version Path.join([__DIR__, "..", "VERSION"])
  |> File.read!()
  |> String.trim()

  def project do
    [
      app: :makerion_init,
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

  def application do
    [
      mod: {MakerionInit.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:mdns, "~> 1.0"},
      {:nerves_firmware_ssh, "~> 0.4"},
      {:nerves_runtime, "~> 0.6"},
      {:nerves_network, "~> 0.5"},
      {:ring_logger, "~> 0.6"},
      {:yaml_elixir, "~> 2.0"}
    ]
  end
end

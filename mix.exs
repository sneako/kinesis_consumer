defmodule KinesisConsumer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kinesis_consumer,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:gen_stage, "~> 0.12.2"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_kinesis, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:jason, "~> 1.0.0-rc.1"},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end
end

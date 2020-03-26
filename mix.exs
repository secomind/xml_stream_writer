defmodule XMLStreamWriter.MixProject do
  use Mix.Project

  def project do
    [
      app: :xml_stream_writer,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.11", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      description: "XML stream writer library",
      maintainers: ["Davide Bettio"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/ispirata/xml_stream_writer",
        "Documentation" => "http://hexdocs.pm/xml_stream_writer"
      }
    ]
  end
end

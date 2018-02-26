defmodule Mach.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mach,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:stream_data, "~> 0.4"}]
  end

  defp aliases do
    [nuke: &nuke/1]
  end

  defp nuke(_) do
    File.rm("time.data")
    File.rm_rf("_build")
  end
end

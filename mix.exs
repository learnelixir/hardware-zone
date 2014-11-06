defmodule HardwareZone.Mixfile do
  use Mix.Project

  def project do
    [ app: :hardware_zone,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      elixirc_paths: ["lib", "web"],
      compilers: [:phoenix] ++ Mix.compilers,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { HardwareZone, [] },
      applications: [:phoenix, :cowboy, :logger, :postgrex, :ecto]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, "0.5.0"},
      {:cowboy, "~> 1.0.0"},
      {:postgrex, "~> 0.5"},
      {:ecto, "~> 0.2.0"},
      {:inflex, "~> 0.2.5"},
      {:mogrify, "~> 0.1"}
    ]
  end
end

defmodule Exoauth.Mixfile do
  use Mix.Project

  def project do
    [ app: :exoauth,
      version: "0.0.1",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps(:prod) do
    [ { :jazz, github: "meh/jazz", tag: "v0.0.3" } ]
  end

  defp deps(_) do
    deps(:prod) ++
      [ { :cowboy, github: "extend/cowboy" },
        { :dynamo, github: "elixir-lang/dynamo" } ]
  end
end

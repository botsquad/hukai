defmodule Hukai.MixProject do
  use Mix.Project

  def project do
    [
      app: :hukai,
      version: File.read!("VERSION"),
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Hukai.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xxhash, "~> 0.2"}
    ]
  end
end

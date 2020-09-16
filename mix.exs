defmodule Hukai.MixProject do
  use Mix.Project

  def project do
    [
      app: :hukai,
      version: File.read!("VERSION"),
      elixir: "~> 1.8",
      description: description(),
      package: package(),
      source_url: "https://github.com/botsquad/hukai",
      homepage_url: "https://github.com/botsquad/hukai",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    "Generate Heroku-like pronouncable strings in Elixir"
  end

  defp package do
    %{
      files: ["lib", "priv", "mix.exs", "*.md", "LICENSE", "VERSION"],
      maintainers: ["Arjan Scherpenisse"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/botsquad/hukai"}
    }
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

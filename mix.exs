defmodule Elixirc.Mixfile do
  use Mix.Project

  def project do
    [app: :elixirc,
     version: "0.1.2",
     description: "An Elixir IRC module providing GenStage/callback based IRC Clients.",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     source_url: "https://github.com/henry232323/elixirc/",
     homepage_url: "https://github.com/henry232323/elixirc/"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.11.1"},
      {:gen_stage, "~> 0.11"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  def package do
    [
      name: :elixirc,
      licenses: ["MIT"],
      maintainers: ["henry232323"],
      links: %{"GitHub" => "https://github.com/henry232323/elixirc/"}
    ]
  end
end

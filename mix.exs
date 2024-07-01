defmodule CommercyfyNotifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :commercyfy_notifier,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CommercyfyNotifier, []},
      extra_applications: [:logger, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.18.0"},
      {:jason, "~> 1.4"}
    ]
  end
end

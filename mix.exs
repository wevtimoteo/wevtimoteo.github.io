defmodule WevtimoteoGithubIo.MixFile do
  use Mix.Project

  def project do
    [
      app: :wevtimoteo_github_io,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:serum]
    ]
  end

  defp deps do
    [
      {:serum, "~> 1.5"},
      {:serum_theme_essence, "~> 1.1"}
    ]
  end
end

# lib/mix/tasks/github.token.ex
defmodule Mix.Tasks.Github.Token do
  use Mix.Task

  @shortdoc "Fetches an installation access token from GitHub"

  @moduledoc """
  This Mix task fetches an installation access token for your GitHub App.

  Usage:
      mix github.token
  """

  def run(_) do
    Mix.Task.run("app.start")  # Ensure app dependencies are started

    app_id = System.get_env("GITHUB_APP_ID") || raise "Missing GITHUB_APP_ID"
    installation_id = System.get_env("GITHUB_INSTALLATION_ID") || raise "Missing GITHUB_INSTALLATION_ID"
    private_key_path = System.get_env("GITHUB_PRIVATE_KEY_PATH") || "priv/github/private-key.pem"

    private_key_pem =
      File.read!(private_key_path)

    case PhoenixUploader.GitHubAuth.get_installation_token(app_id, private_key_pem, installation_id) do
      {:ok, token} ->
        IO.puts("✅ Installation access token:\n\n#{token}")

      {:error, reason} ->
        IO.puts("❌ Failed to get token:\n\n#{reason}")
    end
  end
end

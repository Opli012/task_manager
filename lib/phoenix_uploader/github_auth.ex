defmodule PhoenixUploader.GitHubAuth do
  require JOSE
  alias HTTPoison

  @github_api "https://api.github.com"

  @doc """
  Generate a JWT to authenticate the GitHub App.
  """
  def generate_jwt(app_id, private_key_pem) do
    now = :os.system_time(:second)

    payload = %{
      "iat" => now - 60,
      "exp" => now + 600,
      "iss" => app_id
    }

    private_key = JOSE.JWK.from_pem(private_key_pem)

    {_, jwt} =
      JOSE.JWT.sign(private_key, %{"alg" => "RS256"}, payload)
      |> JOSE.JWS.compact()

    jwt
  end

  @doc """
  Use the JWT to get an installation access token.
  """
  def get_installation_token(app_id, private_key_pem, installation_id) do
    jwt = generate_jwt(app_id, private_key_pem)

    headers = [
      {"Authorization", "Bearer #{jwt}"},
      {"Accept", "application/vnd.github+json"}
    ]

    url = "#{@github_api}/app/installations/#{installation_id}/access_tokens"

    case HTTPoison.post(url, "", headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        {:ok, token_data} = Jason.decode(body)
        {:ok, token_data["token"]}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, "GitHub API returned status #{status}: #{body}"}

      {:error, reason} ->
        {:error, "Request failed: #{inspect(reason)}"}
    end
  end
end

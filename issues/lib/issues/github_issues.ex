defmodule Issues.GithubIssues do
  @api_url Application.get_env(:issues, :github_url)

  @moduledoc """
  Fetch Github Issues
  """

  def fetch(user, project) do
    api_url(user, project)
    |> HTTPoison.get()
    |> handle_reponse
  end

  def api_url(user, project) do
    "#{@api_url}/repos/#{user}/#{project}/issues"
  end

  def handle_reponse({:ok, %{status_code: status_code, body: body}}) do
    {
      check_for_error(status_code),
      Poison.Parser.parse!(body, %{})
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end

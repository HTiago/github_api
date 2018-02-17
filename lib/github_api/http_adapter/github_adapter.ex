defmodule GithubApi.HttpAdapter.GithubAdapter do
  @behaviour GithubApi.HttpAdapter

  def request(url) do
    HTTPoison.get(url)
  end
end

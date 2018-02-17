defmodule GithubApi.HttpAdapter do
  @callback request(String.t) :: 
    {:ok, %{body: String.t}} | {:error, term}
end
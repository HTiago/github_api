defmodule GithubApi.HttpAdapter.TestAdapter do
  @behaviour GithubApi.HttpAdapter
  
  def request(url) do
    send(self(), {:request_url, URI.parse(url)})
    
    body =
    """
    {
      "total_count": 0,
      "items": []
    }
    """
    {:ok, %{body: body}}
  end
end
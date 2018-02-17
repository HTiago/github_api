defmodule GithubApi do
  def search_repos(params) do
    query = build_query(params)

    request("/search/repositories?#{query}")
  end

  def build_query(params) do
    params
    |> Enum.reduce(%{:q => []}, fn {key, value}, acc ->
      case key do
        :term -> Map.update!(acc, :q, &[value | &1])
        :user -> Map.update!(acc, :q, &["user:#{value}" | &1])
        :org -> Map.update!(acc, :q, &["org:#{value}" | &1])
        :page -> Map.put(acc, :page, value)
        :language -> Map.update!(acc, :q, &["language:#{value}" | &1])
      end
    end)
    |> Map.update!(:q, &Enum.join(&1, " "))
    |> URI.encode_query()
  end

  defp request(path) do
    base_url = Application.get_env(:github_api, :api_url)
    http_adapter = Application.get_env(:github_api, :http_adapter)

    url = base_url <> path
    
    {:ok, response} = http_adapter.request(url)
    {:ok, decoded} = Poison.decode(response.body)
    
    result = %{
      total_count: decoded["total_count"],
      items: decoded["items"]
    }

    {:ok, result}
  end
end
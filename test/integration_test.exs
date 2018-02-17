defmodule GithubApi.IntegrationTest do
  use ExUnit.Case, async: false
  
  @moduletag :integration_tests

  setup_all do
    old_adapter = Application.get_env(:github_api, :http_adapter)
    Application.put_env(:github_api, :http_adapter, GithubApi.HttpAdapter.GithubAdapter)

    on_exit fn ->
      Application.put_env(:github_api, :http_adapter, old_adapter)
    end
  end

  
  test "teste de integracao de api do github" do
    {:ok, result} =
      GithubApi.search_repos(%{
        org: "elixir-lang",
        language: "elixir",
        term: "flow"
      })

    assert Enum.any?(result.items, &(&1["name"] == "flow"))
  end
end
defmodule GithubApiTest do
  use ExUnit.Case

  test "permite listar repositórios públicos" do
    assert {:ok, result} = GithubApi.search_repos(%{term: "elixir"})

    assert_received({:request_url, url})
    
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query )
    assert query == %{"q" => "elixir"}

    assert result.total_count
    assert is_list(result.items)

    # assert is_list(repos)
  end

  test "permite listar repositórios de um usuário" do
    assert {:ok, result} = GithubApi.search_repos(%{user: "htiago"})
    assert_received({:request_url, url})
    assert url.path == "/search/repositories"

    assert result.total_count
    assert is_list(result.items)
    
    query = URI.decode_query(url.query )
    assert query == %{"q" => "user:htiago"}

  end

  test "permite listar repositórios de uma organização" do
    assert {:ok, result} = GithubApi.search_repos(%{org: "elixir-lang"})
    assert_received({:request_url, url})
    assert url.path == "/search/repositories"

    assert result.total_count
    assert is_list(result.items)

    query = URI.decode_query(url.query )
    assert query == %{"q" => "org:elixir-lang"}

  end

  test "permite paginar repositorios" do
    assert {:ok, result} = GithubApi.search_repos(%{org: "elixir-lang", page: "2"})
    assert_received({:request_url, url})
    assert url.path == "/search/repositories"

    assert result.total_count
    assert is_list(result.items)

    query = URI.decode_query(url.query )
    assert query == %{"q" => "org:elixir-lang", "page" => "2"}
  end

  test "permite filtrar por linguagem" do
    assert {:ok, result} = GithubApi.search_repos(%{language: "elixir"})
    assert_received({:request_url, url})
    assert url.path == "/search/repositories"

    assert result.total_count
    assert is_list(result.items)

    query = URI.decode_query(url.query )
    assert query == %{"q" => "language:elixir"}
  end

  
  test "permite usar múltiplos filtros" do
    assert {:ok, _result} = GithubApi.search_repos(%{
      user: "josevalim",
      language: "elixir",
      term: "supervisor"
    })
    assert_received({:request_url, url})
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "user:josevalim supervisor language:elixir"}
  end


end
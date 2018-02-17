use Mix.Config

config :github_api, :api_url, "https://api.github.com"

config :github_api, :http_adapter, GithubApi.HttpAdapter.GithubAdapter

import_config "#{Mix.env}.exs"
defmodule Delight.Application do
  use Application
  import Delight.Constants
  require Logger

  def start(_type, _args) do

    children = [
      Delight.Supervisor,
      Delight.Registry,
      {Plug.Cowboy, scheme: :http, plug: Delight.Router, options: [port: 4010]}
      | Enum.flat_map(initial_keywords(), &([%{id: &1, start: {TwitterFetcher, :start_link, [&1]}}]))
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    Logger.info("---- Starting application. ----")

    Supervisor.start_link(children, opts)
  end
end

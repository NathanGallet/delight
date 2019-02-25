defmodule Delight.Application do
  use Application
  require Logger

  @keywords ["microsoft", "apple", "amazon", "netflix", "google", "sony", "nintendo", "blizzard"]
  def start(_type, _args) do

    children = [
      Delight.Supervisor,
      Delight.Registry,
      {Plug.Cowboy, scheme: :http, plug: Delight.Router, options: [port: 4000]}
      | Enum.flat_map(@keywords, &([%{id: &1, start: {TwitterFetcher, :start_link, [&1]}}]))
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    Logger.info("---- Starting application. ----")

    Supervisor.start_link(children, opts)
  end
end

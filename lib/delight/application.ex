defmodule Delight.Application do
  use Application
  require Logger

  def start(_type, _args) do

    children = [
      {Plug.Cowboy, scheme: :http, plug: Delight.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Delight.Supervisor]

    Logger.info("---- Starting application. ----")

    Supervisor.start_link(children, opts)
  end
end

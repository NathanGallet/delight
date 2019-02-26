defmodule Delight.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/ranks" do
    res = Delight.calculate_kpi

    conn
    |> put_req_header("content-type", "application/json")
    |> send_resp(:ok, Poison.encode!(res))
  end

  # TODO: add rank with post

  match _ do
    send_resp(conn, :not_found, "sorry")
  end
end

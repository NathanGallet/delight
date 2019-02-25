defmodule Delight.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  get "/ranks" do
    res = Delight.kpi_initial_keywords

    conn
    |> put_req_header("content-type", "application/json")
    |> send_resp(:ok, Poison.encode!(%{"apple" => 19, "nintendo" => 20}))
  end

  match _ do
    send_resp(conn, :not_found, "sorry")
  end
end

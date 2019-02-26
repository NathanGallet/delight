defmodule Delight.Router do
  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  # Return all KPI for each initial keywords.
  get "/ranks" do
    res = Delight.calculate_kpi

    conn
    |> put_req_header("content-type", "application/json")
    |> send_resp(:ok, Poison.encode!(res))
  end

  # Render kpi for a keyword.
  get "/ranks/:keyword" do
    res = Delight.calculate_kpi_for_keyword(keyword)

    conn
    |> put_req_header("content-type", "application/json")
    |> send_resp(:ok, Poison.encode!(res))
  end

  # Every other routes return `sorry`.
  match _ do
    send_resp(conn, :not_found, "sorry")
  end
end

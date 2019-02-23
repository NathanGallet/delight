defmodule Delight.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/ranks" do
    send_resp(conn, :ok, "yolo")
  end

  match _ do
    send_resp(conn, :not_found, "sorry")
  end
end

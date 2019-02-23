defmodule Delight.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Delight.Router

  @opts Router.init([])

  test "Main route" do
    conn =
      conn(:get, "/ranks", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "yolo"
  end

  test "Others route" do
    conn =
      conn(:get, "/qwoekqp", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "sorry"
  end
end

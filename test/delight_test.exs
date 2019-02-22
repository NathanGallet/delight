defmodule DelightTest do
  use ExUnit.Case
  doctest Delight

  test "greets the world" do
    assert Delight.hello() == :world
  end
end

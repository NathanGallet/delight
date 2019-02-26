defmodule Delight.Constants do
  @moduledoc """
  Using Macro, this module is used to store constants.
  """
  @initial_keywords ["microsoft", "apple", "amazon", "netflix", "google", "sony", "nintendo", "blizzard"]

  defmacro initial_keywords, do: @initial_keywords
end

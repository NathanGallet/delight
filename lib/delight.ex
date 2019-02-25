defmodule Delight do
  require Logger
  @keywords ["microsoft", "apple", "amazon", "netflix", "google", "sony", "nintendo", "blizzard"]

  def test do
    tasks = Enum.reduce(@keywords, [], fn keyword, acc ->
      [ Task.async(fn -> TwitterFetcher.fetch_keyword(keyword) end) | acc ]
    end)

    yolo = Enum.map(tasks, &Task.await/1)

    Logger.info("#################################")
    Logger.info("#{inspect(yolo)}")
    Logger.info("*********************************")
  end
end

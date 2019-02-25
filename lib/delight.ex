defmodule Delight do
  import Delight.Constants
  require Logger

  def kpi_initial_keywords do
    Logger.info("Fetch KPI for initial keywords")

    # Launch all Genserver at once.
    tasks = Enum.reduce(initial_keywords(), [], fn keyword, acc ->
      [ Task.async(fn -> TwitterFetcher.fetch_keyword(keyword) end) | acc ]
    end)

    # Wait results.
    result = Enum.map(tasks, &Task.await/1)

    Logger.info("#################################")
    Logger.info("#{inspect(result)}")
    Logger.info("*********************************")
  end
end

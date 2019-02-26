defmodule Delight do
  import Delight.Constants

  def calculate_kpi do
    # Launch all Genserver at once.
    tasks = Enum.reduce(initial_keywords(), [], fn keyword, acc ->
      [ Task.async(fn -> TwitterFetcher.fetch_keyword(keyword) end) | acc ]
    end)

    # Wait results.
    Enum.map(tasks, &Task.await/1)
  end
end

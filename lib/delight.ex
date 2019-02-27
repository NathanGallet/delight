defmodule Delight do
  import Delight.Constants
  @moduledoc """
  Allow us to fetch some keywords from twitter.
  """

  @doc """
  Return result for each initial keyword.
  It will launch asynchronously each Genserver then wait for them to fetch and handle responses.
  """
  def calculate_kpi do
    # Launch all Genserver at once.
    tasks = Enum.reduce(initial_keywords(), [], fn keyword, acc ->
      [Task.async(fn -> TwitterFetcher.fetch_keyword(keyword) end) | acc]
    end)

    # Wait results.
    tasks
    |> Enum.map(&Task.await/1)
    |> format_response
  end

  @doc """
  Fetch from Twitter using `keyword` in order to calculate the KPI.
  It launch a new GenServer if there is not any registered.
  """
  def calculate_kpi_for_keyword(keyword) do
    # Check if the GenServer with this name is launched.
    is_genserver_launched? =
      Delight.Registry.get_map
      |> Enum.any?(&(is_register?(&1, keyword)))

    # If not, initialisation of the server using the DynamicSupervisor.
    if(not is_genserver_launched?, do: Delight.Supervisor.start_fetcher(keyword))

    # Fetch keyword.
    TwitterFetcher.fetch_keyword(keyword)
  end

  # Check if the name is in the Tuple.
  defp is_register?(registered_key, name) do
    {{:keyword, key}, _pid} = registered_key
    key == name
  end

  # Format response for multiple key.
  defp format_response(results) do
    results
    |> Enum.reduce(%{},
    fn result, acc ->
      [{key, value}] = Map.to_list(result)

      Map.put(acc, key, value)
    end)
  end
end

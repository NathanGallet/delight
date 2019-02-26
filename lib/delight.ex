defmodule Delight do
  import Delight.Constants

  def calculate_kpi do
    # Launch all Genserver at once.
    tasks = Enum.reduce(initial_keywords(), [], fn keyword, acc ->
      [ Task.async(fn -> TwitterFetcher.fetch_keyword(keyword) end) | acc ]
    end)

    # Wait results.
    tasks
    |> Enum.map(&Task.await/1)
    |> format_response
  end

  def calculate_kpi_for_keyword(name) do
    # Check if the GenServer with this name is launched.
    is_genserver_launched? =
      Delight.Registry.get_map
      |> Enum.any?(&(is_register?(&1, name)))

    # If not, initialisation of the server using the DynamicSupervisor.
    if(not is_genserver_launched?, do: Delight.Supervisor.start_fetcher(name))

    # Fetch keyword.
    TwitterFetcher.fetch_keyword(name)
  end

  defp is_register?(registered_key, name) do
    {{:keyword, key}, _pid} = registered_key
    key == name
  end

  defp format_response(results) do
    results
    |> Enum.reduce(%{},
    fn result, acc ->
      [{key, value}] = Map.to_list(result)

      Map.put(acc, key, value)
    end)
  end
end

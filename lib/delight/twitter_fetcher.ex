defmodule TwitterFetcher do
  @moduledoc """
  This module is the GenServer.
  The `state` of this GenServer is the name that the process need to work with.
  """

  use GenServer
  require Logger

  #########################################
  #                 API                   #
  #########################################

  def start_link(name) do
    Logger.info("Starting GenServer with search keyword : #{inspect(name)}" )
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def fetch_keyword(keyword) do
    GenServer.call(via_tuple(keyword), :fetch_keyword_kpi)
  end

  defp via_tuple(keyword) do
    {:via, Delight.Registry, {:keyword, keyword}}
  end

  #########################################
  #                SERVER                 #
  #########################################

  def init(keyword) do
    {:ok, keyword}
  end

  @doc """
  Fetch `search_word` from Twitter and calculate the KPI.
  Return %{search_word => value}.
  """
  def handle_call(:fetch_keyword_kpi, _from, search_keyword) do
    Logger.info("Fetch keyword : #{inspect(search_keyword)} from Twitter")
    response =
      search_keyword
      |> ExTwitter.search([count: 100])              # Fetch 100 twitte.
      |> Stream.map(&(Map.get(&1, :created_at)))     # Get created_at value for each of them.
      |> Stream.map(&(convert_created_at_to_unix/1)) # Convert this date.
      |> Enum.to_list                                # Convert to list.
      |> average()                                   # Calculate the KPI.

    Logger.info("#{inspect(search_keyword)} finished")
    {:reply, %{search_keyword => response}, search_keyword}
  end

  # Using Timex to convert date format to unix.
  defp convert_created_at_to_unix(date) do
    {:ok, date_time} = Timex.parse(date, "{WDshort} {Mshort} {D} {h24}:{m}:{s} {Z} {YYYY}")
    Timex.to_unix(date_time)
  end

  # Calculate gaps between each unix timestamp.
  defp average(list, result \\ []) do
    case length(list) do
      2 ->
        [first, second] = list

        result = [abs(second - first) | result]
        calculate_kpi(result)
      _ ->
        [first | [second | tail]] = list

        result = [abs(second - first) | result]
        list   = [second | tail]
        average(list, result)
    end
  end

  # Calculate average of value for Twitte and compare this to 1 minutes (60 seconds).
  defp calculate_kpi(list), do: Float.round(60 / (Enum.sum(list) / length(list)), 2)
end

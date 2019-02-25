defmodule TwitterFetcher do
  use GenServer
  require Logger

  #########################################
  #                 API                   #
  #########################################

  def start_link(name) do
    Logger.info("Starting module with search keyword : #{inspect(name)}" )
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def fetch_keyword(keyword) do
    GenServer.call(via_tuple(keyword), :fetch_keyword_kpi, 100000)
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

  def handle_call(:fetch_keyword_kpi, _from, search_keyword) do
    Logger.info("Fetch keyword : #{inspect(search_keyword)} from Twitter" )
    response =
      search_keyword
      |> ExTwitter.search([count: 100])
      |> Stream.map(&(Map.get(&1, :created_at)))
      |> Stream.map(&(convert_created_at_to_unix/1))
      |> Enum.to_list
      |> average()
      |> calculate_average()

    Logger.info("#{inspect(search_keyword)} finished" )
    {:reply, %{search_keyword => response}, search_keyword}
  end

  defp average(list, result \\ [])
  defp average(list, result) do
    [ first | [ second | tail ]] = list
    result = [ abs(second - first) | result ]

    case length(tail) do
      n when n in [2, 3] -> result
      _                  -> average(tail, result)
    end
  end

  defp calculate_average(list), do: Enum.sum(list)/length(list)

  defp convert_created_at_to_unix(date) do
    {:ok, date_time} = Timex.parse(date, "{WDshort} {Mshort} {D} {h24}:{m}:{s} {Z} {YYYY}")
    Timex.to_unix(date_time)
  end
end

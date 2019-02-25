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
    GenServer.call(via_tuple(keyword), :fetch_keyword)
  end

  defp via_tuple(keyword) do
    {:via, Delight.Registry, {:keyword, keyword}}
  end

  #########################################
  #                SERVER                 #
  #########################################

  @doc """
  GenServer.init/1 callback
  """
  def init(keyword) do
    {:ok, keyword}
  end

  def handle_call(:fetch_keyword, _from, keyword) do
    Logger.info("Fetch keyword : #{inspect(keyword)} from Twitter" )
    zbra =
      keyword
      |> ExTwitter.search([count: 100])
      |> Enum.map(&(&1.created_at))

    Logger.info("#{inspect(keyword)} finished" )
    {:reply, keyword, zbra}
  end
end

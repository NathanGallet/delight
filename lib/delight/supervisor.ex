defmodule Delight.Supervisor do
  use DynamicSupervisor
  require Logger

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_fetcher(name) do
    DynamicSupervisor.start_child(__MODULE__, {TwitterFetcher, name: name})
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

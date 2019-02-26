defmodule Delight.Supervisor do
  @moduledoc """
  This module is used as a Supervisor for new TwitterFetcher.
  It will start them dynamically.
  """

  use DynamicSupervisor

  @doc """
  Start a new TwitterFetcher with a keyword.
  """
  def start_fetcher(name) do
    DynamicSupervisor.start_child(__MODULE__, {TwitterFetcher, name})
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

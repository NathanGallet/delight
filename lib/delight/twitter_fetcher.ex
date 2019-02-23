defmodule TwitterRecuperator do
  use GenServer
  require Logger

  @doc """
  Start our queue and link it.
  This is a helper function
  """
  def start_link(state \\ []) do
    Logger.info("Starting module with state : #{inspect(state)}" )
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}

  def handle_call(:dequeue, _from, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}


  def queue, do: GenServer.call(__MODULE__, :queue)
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
end

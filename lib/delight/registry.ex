defmodule Delight.Registry do
  use GenServer

  ####################
  #       API        #
  ####################

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def whereis_name(search_keyword) do
    GenServer.call(__MODULE__, {:whereis_name, search_keyword})
  end

  def register_name(search_keyword, pid) do
    GenServer.call(__MODULE__, {:register_name, search_keyword, pid})
  end

  def get_map do
    GenServer.call(__MODULE__, :get_map)
  end

  def unregister_name(search_keyword) do
    GenServer.cast(__MODULE__, {:unregister_name, search_keyword})
  end

  ####################
  #      SERVER      #
  ####################

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, fetcher_name}, _from, state) do
    {:reply, Map.get(state, fetcher_name, :undefined), state}
  end

  def handle_call({:register_name, fetcher_name, pid}, _from, state) do
    case Map.get(state, fetcher_name) do
      nil ->
        {:reply, :yes, Map.put(state, fetcher_name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_call(:get_map, _from, map) do
    {:reply, map, map}
  end

  def handle_cast({:unregister_name, fetcher_name}, state) do
    {:noreply, Map.delete(state, fetcher_name)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid  != pid_to_remove end

    state
    |> Enum.filter(remove)
    |> Enum.into(%{})
  end
end

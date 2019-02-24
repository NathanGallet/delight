defmodule Delight.Registry do
  use GenServer

  ####################
  #       API        #
  ####################

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def whereis_name(search_keyword) do
    GenServer.call(__MODULE__, {:whereis_name, search_keyword})
  end

  def register_name(search_keyword, pid) do
    GenServer.call(__MODULE__, {:register_name, search_keyword, pid})
  end

  def unregister_name(search_keyword) do
    GenServer.cast(__MODULE__, {:unregister_name, search_keyword})
  end

  def send(search_keyword, message) do
    case whereis_name(search_keyword) do
      :undefined ->
        {:badarg, {search_keyword, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  ####################
  #      SERVER      #
  ####################

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, room_name}, _from, state) do
    {:reply, Map.get(state, room_name, :undefined), state}
  end

  def handle_call({:register_name, room_name, pid}, _from, state) do
    case Map.get(state, room_name) do
      nil ->
        {:reply, :yes, Map.put(state, room_name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, room_name}, state) do
    {:noreply, Map.delete(state, room_name)}
  end
end

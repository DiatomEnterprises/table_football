defmodule TableFootball.Table do
  use GenServer

  def start_link do
    options = %{left_player_id: nil, right_player_id: nil, game_pid: nil, subscribers: []}
    GenServer.start(__MODULE__, options, name: __MODULE__)
  end

  def register_player(id) do
    GenServer.cast(__MODULE__, {:register_player, id})
  end

  def handle_cast({:register_player, id}, %{game_pid: game_pid} = state) when is_pid(game_pid) do
    {:noreply, state}
  end

  def handle_cast({:register_player, id}, %{left_player_id: nil, game_pid: nil} = state) do
    new_state = add_left_player(state, id)
    {:noreply, new_state}
  end

  def handle_cast({:register_player, id}, %{left_player_id: id, game_pid: nil} = state) do
    {:noreply, state}
  end

  def handle_cast({:register_player, id}, %{right_player_id: nil, game_pid: nil} = state) do
    new_state = add_right_player_and_spawn_game(state, id)
    {:noreply, new_state}
  end

  defp add_left_player(state, id) do
    Dict.merge(state, %{left_player_id: id})
  end

  defp add_right_player_and_spawn_game(state = %{left_player_id: left_player_id}, id) do
    {:ok, game_pid} = TableFootball.GameLogic.start_link(left_player_id: left_player_id, right_player_id: id)
    Dict.merge(state, %{right_player_id: id, game_pid: game_pid})
  end

  def get_state do
    GenServer.call(__MODULE__, {:get_state})
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end
end

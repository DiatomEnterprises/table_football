defmodule TableFootball.Table do
  use GenServer

  def start_link do
    options = %{left_player_id: nil, right_player_id: nil, game_pid: nil}
    GenServer.start(__MODULE__, options, name: __MODULE__)
  end

  def register_player(id) do
    GenServer.cast(__MODULE__, {:register_player, id})
  end

  def handle_cast({:register_player, id}, state) do
    new_state = case state do
      %{left_player_id: nil, game_pid: nil} ->
        add_left_player(state, id)
      %{left_player_id: ^id, right_player_id: ^id, game_pid: nil} ->
        state
      %{right_player_id: nil, game_pid: nil} ->
        add_right_player_and_spawn_game(state, id)
      %{game_pid: _pid} ->
        state
    end
    {:noreply, new_state}
  end

  def get_state do
    GenServer.call(__MODULE__, {:get_state})
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def add_left_player(state, id) do
    Dict.merge(state, %{left_player_id: id})
  end

  def add_right_player_and_spawn_game(state, id) do
    %{left_player_id: left_player_id} = state
    {:ok, game_pid} = TableFootball.GameLogic.start_link(left_player_id: left_player_id, right_player_id: id)
    Dict.merge(state, %{right_player_id: id, game_pid: game_pid})
  end
end

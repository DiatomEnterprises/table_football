defmodule TableFootball.GameLogic do
  use GenServer

  def start_link(left_player_id: left_player_id, right_player_id: right_player_id) do
    game_state = %TableFootball.Game{
      left_player_id: left_player_id,
      right_player_id: right_player_id,
      left_score: 0,
      right_score: 0
    }
    GenServer.start(__MODULE__, game_state)
  end

  def add_score(pid, side) do
    {:ok, game_state} = GenServer.call pid, {:point, side}
    game_state
  end

  def handle_call({:point, :right}, _from, game_state) do
    new_game_state = %{game_state | right_score: game_state.right_score + 1}
    {:reply, {:ok, new_game_state}, new_game_state}
  end

  def handle_call({:point, :left}, _from, game_state) do
    new_game_state = %{game_state | left_score: game_state.left_score + 1}
    {:reply, {:ok, new_game_state}, new_game_state}
  end

  def stop_game(pid) do
    GenServer.call pid, {:stop_game}
    {:ok, "Game process terminated"}
  end

  def handle_call({:stop_game}, _from,  game_state) do
    {:stop, :normal, :ok, game_state}
  end
end

defmodule TableFootball.GameLogic do
  use GenServer
  alias TableFootball.Game
  alias TableFootball.EventBus

  def start_link(left_player_id: left_player_id, right_player_id: right_player_id) do
    game_state = %Game{
      left_player_id: left_player_id,
      right_player_id: right_player_id,
      left_score: 0,
      right_score: 0
    }
    GenServer.start_link(__MODULE__, game_state)
  end

  def init(game_state) do
    EventBus.subscribe(self, :score)
    {:ok, game_state}
  end

  def handle_info({:score, :right}, %Game{right_score: 9} = game_state) do
    new_game_state = %{game_state | right_score: game_state.right_score + 1}
    EventBus.notify(:victory, new_game_state)
    EventBus.unsubscribe(self, :score)
    {:stop, :normal, new_game_state}
  end

  def handle_info({:score, :left}, %Game{left_score: 9} = game_state) do
    new_game_state = %{game_state | left_score: game_state.left_score + 1}
    EventBus.notify(:victory, new_game_state)
    EventBus.unsubscribe(self, :score)
    {:stop, :normal, new_game_state}
  end

  def handle_info({:score, :right}, game_state) do
    new_game_state = %{game_state | right_score: game_state.right_score + 1}
    EventBus.notify(:game_update, new_game_state)
    {:noreply, new_game_state}
  end

  def handle_info({:score, :left}, game_state) do
    new_game_state = %{game_state | left_score: game_state.left_score + 1}
    EventBus.notify(:game_update, new_game_state)
    {:noreply, new_game_state}
  end
end

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
    spawn(__MODULE__, :start_game, [game_state])
  end

  def start_game(game_state) do
    EventBus.subscribe(self, :score)
    listen(game_state)
  end

  def listen(game_state) do
    new_game_state = receive do
      {:score, :right} -> %{game_state | right_score: game_state.right_score + 1}
      {:score, :left} -> %{game_state | left_score: game_state.left_score + 1}
    end
    case handle_logic(new_game_state) do
      :ok -> listen(new_game_state)
      :victory -> nil
    end
  end

  def handle_logic(%Game{right_score: 10} = game) do
    EventBus.notify(:victory, game)
    EventBus.unsubscribe(self, :score)
    :victory
  end

  def handle_logic(%Game{left_score: 10} = game) do
    EventBus.notify(:victory, game)
    EventBus.unsubscribe(self, :score)
    :victory
  end

  def handle_logic(game) do
    EventBus.notify(:game_update, game)
    :ok
  end
end

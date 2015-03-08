defmodule TableFootball.GameLogicTest do
  use ExUnit.Case
  alias TableFootball.Game
  alias TableFootball.GameLogic
  alias TableFootball.EventBus
  setup do
    EventBus.start_link
    :ok
  end

  test "checking if left player has won" do
    GameLogic.start_link(left_player_id: 1, right_player_id: 2)
    EventBus.subscribe(self, :victory)
    EventBus.subscribe(self, :game_update)
    Enum.each(1..5, fn(_)-> EventBus.notify(:score, :left) end)
    Enum.each(1..5, fn(i)-> assert_receive({ :game_update, %Game{ left_score: ^i}}) end)
    Enum.each(1..5, fn(_)-> EventBus.notify(:score, :right) end)
    Enum.each(1..5, fn(i)-> assert_receive({ :game_update, %Game{ right_score: ^i}}) end)
    Enum.each(6..10, fn(_)-> EventBus.notify(:score, :left) end)
    Enum.each(6..9, fn(i)-> assert_receive({ :game_update, %Game{ left_score: ^i}}) end)
    assert_receive({:victory, %Game{left_player_id: 1, right_player_id: 2, left_score: 10, right_score: 5}})
  end
end

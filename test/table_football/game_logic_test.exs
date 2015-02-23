defmodule TableFootball.GameLogicTest do
  use ExUnit.Case, async: true
  require TableFootball.Game

  test "checking result with Left 2 : Right 1" do
    {:ok, game_logic_pid} = TableFootball.GameLogic.start_link(left_player_id: 1, right_player_id: 2)

    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :left)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 1, right_score: 0})
    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :right)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 1, right_score: 1})
    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :left)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 2, right_score: 1})
  end

  test "checking result with Left 1 : Right 2" do
    {:ok, game_logic_pid} = TableFootball.GameLogic.start_link(left_player_id: 1, right_player_id: 2)

    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :right)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 0, right_score: 1})
    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :right)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 0, right_score: 2})
    {:ok, game_score} = {:ok, TableFootball.GameLogic.add_score(game_logic_pid, :left)}
    assert(game_score == %TableFootball.Game{left_player_id: 1, right_player_id: 2, left_score: 1, right_score: 2})
  end

  test "stopping of games" do
    {:ok, game_logic_pid} = TableFootball.GameLogic.start_link(left_player_id: 1, right_player_id: 2)
    {:ok, "Game process terminated"} = TableFootball.GameLogic.stop_game(game_logic_pid)
    assert(Process.alive?(game_logic_pid) == false)
  end
end

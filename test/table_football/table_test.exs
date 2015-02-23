defmodule TableFootball.TableTest do
  use ExUnit.Case, async: true

  test "add player to table" do
    TableFootball.Table.start_link
    TableFootball.Table.register_player(123)
    TableFootball.Table.register_player(321)
    TableFootball.Table.register_player(111)
    %{left_player_id: lp_id, right_player_id: rp_id, game_pid: pid} = TableFootball.Table.get_state
    assert lp_id == 123
    assert rp_id == 321
    assert Process.alive?(pid)
  end

  test "add subscriber for goal" do

  end
end

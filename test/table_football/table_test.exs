defmodule TableFootball.TableTest do
  use ExUnit.Case, async: true
  alias TableFootball.EventBus

  test "add two players to the table" do
    EventBus.subscribe(self, :game_started)
    EventBus.subscribe(self, :victory)
    EventBus.notify(:player_join, 123)
    EventBus.notify(:player_join, 321)
    Enum.each(1..10, fn (_) ->EventBus.notify(:score, :left)end)
    assert_receive({:game_started, :ok})
    assert_receive({:victory, _game})
  end
end

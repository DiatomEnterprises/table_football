defmodule TableFootball.TableTest do
  use ExUnit.Case, async: true
  alias TableFootball.EventBus
  alias TableFootball.Table

  setup do
    EventBus.start_link
    :ok
  end

  test "add two players to the table" do
    Table.start_link
    EventBus.subscribe(self, :game_started)
    EventBus.subscribe(self, :victory)
    EventBus.notify(:player_join, 123)
    EventBus.notify(:player_join, 321)
    Enum.each(1..10, fn (_) ->EventBus.notify(:score, :left)end)
    assert_receive({:game_started, :ok})
    assert_receive({:victory, game})
  end
end

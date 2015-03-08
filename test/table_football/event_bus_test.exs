defmodule TableFootball.EventBusTest do
  use ExUnit.Case, async: true
  alias TableFootball.EventBus

  setup do
    EventBus.start_link
    :ok
  end

  test "subscribe to ping and notify about ping" do
    EventBus.subscribe(self, :ping)
    EventBus.notify(:ping, :ok)
    assert_receive({:ping, :ok})
  end

  test "subscribe to ping and notify about ping and pong" do
    EventBus.subscribe(self, :ping)
    EventBus.notify(:ping, :ping)
    EventBus.notify(:pong, :pong)
    assert_receive({:ping, :ping})
    refute_receive({:pong, :pong})
  end

  test "subscribe to ping and pong and notify about ping and pong" do
    EventBus.subscribe(self, :ping)
    EventBus.subscribe(self, :pong)
    EventBus.notify(:ping, :ping)
    EventBus.notify(:pong, :pong)
    assert_receive({:ping, :ping})
    assert_receive({:pong, :pong})
  end

  test "subscribe two times to single event" do
    EventBus.subscribe(self, :ping)
    EventBus.subscribe(self, :ping)
    EventBus.notify(:ping, :ping)
    assert_receive({:ping, :ping})
    refute_receive({:ping, :ping})
  end

  test "unsubscribe" do
    EventBus.subscribe(self, :ping)
    EventBus.notify(:ping, :ping)
    assert_receive({:ping, :ping})
    EventBus.unsubscribe(self, :ping)
    EventBus.notify(:ping, :ping)
    refute_receive({:ping, :ping})
  end
end

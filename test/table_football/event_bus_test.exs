defmodule TableFootball.EventBusTest do
  use ExUnit.Case, async: true
  alias TableFootball.EventBus

  setup do
    EventBus.start_link
    :ok
  end

  test "subscribe to ping and notify about ping" do
    EventBus.subscribe(:ping)
    EventBus.notify(:ping, :ok)
    assert_receive(:ok)
  end

  test "subscribe to two events" do
    EventBus.subscribe(:ping)
    EventBus.notify(:ping, :ping)
    EventBus.notify(:pong, :pong)
    assert_receive(:ping)
    refute_receive(:pong)
  end

  test "subscribe two times to single action" do
    EventBus.subscribe(:ping)
    EventBus.subscribe(:ping)
    EventBus.notify(:ping, :ping)
    assert_receive(:ping)
    refute_receive(:ping)
  end

  test "unsubscribe" do
    EventBus.subscribe(:ping)
    EventBus.notify(:ping, :ping)
    assert_receive(:ping)
    EventBus.unsubscribe(:ping)
    EventBus.notify(:ping, :ping)
    refute_receive(:ping)
  end
end

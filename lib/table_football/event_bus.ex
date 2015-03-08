defmodule TableFootball.EventBus do
  use GenServer

  def start_link do
    GenServer.start(__MODULE__, HashDict.new, name: __MODULE__)
  end

  def subscribe(pid, event) do
    GenServer.call(__MODULE__, {:subscribe, event, pid})
  end

  def handle_call({:subscribe, event, pid}, _from, state) do
    new_state = add_subscriber_to_event(state, pid, event)
    {:reply, new_state, new_state}
  end

  defp add_subscriber_to_event(state, pid, event) do
    case Dict.fetch(state, event) do
      {:ok, subscribed_pids} -> HashDict.put(state, event, Enum.uniq([pid | subscribed_pids]))
      :error -> HashDict.put(state, event, [pid])
    end
  end

  def notify(event, data) do
    GenServer.call(__MODULE__, {:notify, event, data})
  end

  def handle_call({:notify, event, data}, _from, state) do
    case Dict.fetch(state, event) do
      {:ok, subscribed_pids} ->  Enum.each(subscribed_pids, fn(p) -> send(p, {event, data}) end)
      :error -> nil
    end
    {:reply, state, state}
  end

  def unsubscribe(pid, event) do
    GenServer.call(__MODULE__, {:unsubscribe, event, pid})
  end

  def handle_call({:unsubscribe, event, pid}, _from, state) do
    new_state = remove_subscriber_from_event(state, pid, event)
    {:reply, new_state, new_state}
  end

  defp remove_subscriber_from_event(state, pid, event) do
    case Dict.fetch(state, event) do
      {:ok, subscribed_pids} -> HashDict.put(state, event, Enum.filter(subscribed_pids, fn(e) -> e != pid end))
      :error -> state
    end
  end
end

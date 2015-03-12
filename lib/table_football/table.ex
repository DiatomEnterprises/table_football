defmodule TableFootball.Table do
  alias TableFootball.EventBus
  alias TableFootball.GameLogic
  use Application
  use GenServer

  def start(_,_) do
    start_link
  end

  def start_link do
    GenServer.start_link(__MODULE__, %{game_pid: nil, left_player_id: nil, right_player_id: nil}, name: __MODULE__)
  end

  def init(game_state) do
    EventBus.start_link
    EventBus.subscribe(self, :player_join)
    EventBus.subscribe(self, :victory)
    {:ok, game_state}
  end

  defp handle_victory do
    %{game_pid: nil, left_player_id: nil, right_player_id: nil}
  end

  defp handle_game_state(%{game_pid: game_pid} = game, _player_id) when is_pid(game_pid) do
    game
  end

  defp handle_game_state(%{left_player_id: nil} = game, player_id) do
    %{game | left_player_id: player_id}
  end

  defp handle_game_state(%{left_player_id: id, right_player_id: id} = game, _player_id) do
    game
  end

  defp handle_game_state(%{left_player_id: left_player_id, right_player_id: nil} = game, right_player_id) do
    %{game | right_player_id: right_player_id}
    game_pid = GameLogic.start_link(left_player_id: left_player_id, right_player_id: right_player_id)
    EventBus.notify(:game_started, :ok)
    %{game | game_pid: game_pid}
  end

  def handle_info({:player_join, player_id}, state) do
    {:noreply, handle_game_state(state, player_id)}
  end

  def handle_info({:victory, _game}, _state) do
    {:noreply, handle_victory}
  end
end


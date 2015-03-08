defmodule TableFootball.Table do
  alias TableFootball.EventBus
  alias TableFootball.GameLogic

  def start_link() do
    pid = spawn_link(__MODULE__, :start_table, [%{game_pid: nil, left_player_id: nil, right_player_id: nil}])
    EventBus.subscribe(pid, :player_join)
    pid
  end

  def start_table(game) do
    listen(game)
  end

  defp listen(game) do
    new_game_state = receive do
      {:player_join, player_id} ->
        handle_game_state(game, player_id)
      {:victory, :ok} -> handle_victory(game)
    end
    listen(new_game_state)
  end

  defp handle_victory(_game) do
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
end


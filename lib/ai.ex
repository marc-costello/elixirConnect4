defmodule Ai do
  alias GameSettings, as: GS

  @type minimax_minimax_node :: {Enum, {number, number}}

  def calculate_best_move(board, depth) do
     0..GS.max_column_index
     |> Enum.map (fn i ->
       case Board.drop_coin(i, board, %Player{type: :computer, colour: :yellow}) do
         :error -> {i, 0}
         {:ok, updated_board, _player, coord} -> {i, max_move({updated_board, coord}, depth)}
       end
     end)
  end

  def max_move(minimax_node, depth) do
     player = %Player{type: :computer, colour: :yellow}
     {board, move_coord} = minimax_node

     if depth == 0 || is_terminal?(minimax_node) do
         heuristic(move_coord, board, player)
     else
          get_states(board, player)
          |> Enum.map(fn x -> heuristic(x.coord, x.board, player) end)
          |> Enum.reduce(0, fn (child, best_value) ->
             val = min_move(minimax_node, depth - 1)
             min(best_value, val.value)
          end)
     end
  end

  def min_move(minimax_node, depth) do
     player = %Player{type: :human, colour: :red}
     {board, move_coord} = minimax_node

     if depth == 0 do
         heuristic(move_coord, board, player)
     else
          get_states(board, player)
          |> Enum.map(fn x -> heuristic(x.coord, x.board, player) end)
          |> Enum.reduce(0, fn (child, best_value) ->
             val = max_move(minimax_node, depth - 1)
             max(best_value, val.value)
          end)
      end
  end

  def get_states(board, player) do
    0..GS.max_column_index
    |> Enum.map (fn i ->
      case Board.drop_coin(i, board, player) do
        :error -> raise "unable to drop coin"
        {:ok, updated_board, player, coord} -> %{board: updated_board, coord: coord}
      end
    end)
  end

  def heuristic(move_coord, board, player) when player == %Player{type: :human, colour: :red} do
       case Detector.game_state(board, move_coord, player.colour) do
         {:win, _, _} -> %{terminal: true, value: -10}
         {:draw} -> %{terminal: true, value: 0}
         _ -> %{terminal: false, value: 0}
       end
  end

  def heuristic(move_coord, board, player) when player == %Player{type: :computer, colour: :yellow} do
       case Detector.game_state(board, move_coord, player.colour) do
         {:win, _, _} -> %{terminal: true, value: 10}
         {:draw} -> %{terminal: true, value: 0}
         _ -> %{terminal: false, value: 0}
       end
  end

  defp is_terminal?(minimax_node) do
    
  end

  def get_random() do
     :random.seed(:erlang.system_time)
     :random.uniform(GS.max_column_index)
  end
end

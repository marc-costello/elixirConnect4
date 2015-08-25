defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, depth) do
     0..GS.max_column_index
     |> Enum.map (fn i -> { i, max_move(board, depth) } end)
  end

  def max_move(node, depth) do
     player = %Player{type: :computer, colour: :yellow}
     {board, move_coord} = node

     if depth == 0 do
         heuristic(move_coord, board, player)
     else
        child_nodes =
            get_states(node, player)
            |> Enum.map(fn x -> heuristic(x.coord, x.board, player) end)
            |> Enum.reduce(0, fn (child, best_value) ->
               val = min_move(node, depth - 1)
               min(best_value, val)
            end)
     end
  end

  def min_move({}, depth) do
     player = %Player{type: :human, colour: :red}
     {board, move_coord} = node

     if depth == 0 do
         heuristic(move_coord, board, player)
     else
        child_nodes =
            get_states(node, player)
            |> Enum.map(fn x -> heuristic(x.coord, x.board, player) end)
            |> Enum.reduce(0, fn (child, best_value) ->
               val = max_move(node, depth - 1)
               max(best_value, val)
            end)
      end
  end

  def get_states(board, player) do
    0..GS.max_column_index
    |> Enum.map fn i ->
      case Board.drop_coin(i, board, player) do
        :error -> {board, 0}
        {:ok, updated_board, player, coord} -> %{board: updated_board, coord: coord}
      end
    end
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

  def get_random() do
     :random.seed(:erlang.system_time)
     :random.uniform(GS.max_column_index)
  end
end

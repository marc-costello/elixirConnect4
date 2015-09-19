defmodule Connect4.Node do
  defstruct board: nil, terminal: false, coord: nil, value: 0
end

defmodule Ai do
  alias GameSettings, as: GS
  alias Connect4.Node

  @computer %Player{type: :computer, colour: :yellow}
  @human %Player{type: :human, colour: :red}

  def calculate_best_move(board, depth) do
     # to initalise, call max_move on each of the columns.
     0..GS.max_column_index
     |> Enum.map (fn i ->
           case Board.drop_coin(i, board, @computer) do
             :error -> raise "unable to drop coin"
             {:ok, updated_board, _player, coord} -> max_move(%Node{board: updated_board, terminal: false, coord: coord}, depth)
           end
        end)
    #  |> Enum.with_index
    #  |> Enum.sort(fn {valueA, _iA}, {valueB, _iB} ->
    #       valueA > valueB
    #     end)
    #  |> Enum.at(0)
    #  |> elem(1)
  end

  @doc """
  Max - Returns a single value which represents all child nodes for max player.
  node = %{board: updated_board, terminal: false, coord: coord}
  """
  def max_move(node, depth) do
    if depth < 0 || node.terminal do
      IO.puts "MAX - i've reached depth end or terminal node - #{inspect(node)}"
      node.value
    else
      get_child_nodes(node.board, @computer)
      |> Enum.reduce(0, fn(child_node, acc) ->
            # child_node = %Node{board, terminal, coord}
            heu = heuristic(child_node.coord, child_node.board, @computer)
            max(heu.value, min_move(child_node, depth - 1))
         end)
    end
  end

  # function minimax( node, depth )
  #  if node is a terminal node or depth <= 0:
  #      return the heuristic value of node
  #
  #  α = -∞
  #  foreach child in node:
  #     α = max( a, -minimax( child, depth-1 ) )
  #
  #  return α

  # MaxMove (GamePosition game) {
  #   if (GameEnded(game)) {
  #     return EvalGameState(game);
  #   }
  #   else {
  #     best_move < - {};
  #     moves <- GenerateMoves(game);
  #     ForEach moves {
  #        move <- MinMove(ApplyMove(game));
  #        if (Value(move) > Value(best_move)) {
  #           best_move < - move;
  #        }
  #     }
  #     return best_move;
  #   }
  # }

  @doc """
  Max - Returns a single value which represents all child nodes for max player.
  node = %{board: updated_board, terminal: false, coord: coord}
  """
  def min_move(node, depth) do
    if depth < 0 || node.terminal do
      IO.puts "MIN - i've reached depth end or terminal node - #{inspect(node.value)}"
      node.value
    else
      get_child_nodes(node.board, @human)
      |> Enum.reduce(0, fn(child_node, _acc) ->
            # child_node = %Node{board, terminal, coord}
            heu = heuristic(child_node.coord, child_node.board, @human)
            min(heu.value, max_move(child_node, depth - 1))
         end)
    end
  end


  @doc """
  Returns the updated board and coord of the move in a map.
  e.g. %{board: board, coord: {x,y}}
  """
  def get_child_nodes(board, player) do
    0..GS.max_column_index
    |> Enum.map (fn i ->
      case Board.drop_coin(i, board, player) do
        :error -> %Node{board: board, terminal: true, coord: nil}
        {:ok, updated_board, _player, coord} -> %Node{board: updated_board, coord: coord, terminal: false}
      end
    end)
  end

  def heuristic(move_coord, board, player) when player == @human do
       case Detector.game_state(board, move_coord, player.colour) do
         {:win, _, _} -> %{terminal: true, value: -10}
         {:draw} -> %{terminal: true, value: 0}
         _ -> %{terminal: false, value: 0}
       end
  end

  def heuristic(move_coord, board, player) when player == @computer do
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

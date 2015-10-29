defmodule Connect4.Node do
  defstruct board: nil, terminal: false, coord: nil, value: 0
end

defmodule Ai do
  alias GameSettings, as: GS
  alias Connect4.Node

  @computer %Player{type: :computer, colour: :yellow}
  @human %Player{type: :human, colour: :red}

  def calculate_best_move(board, depth) do
    res = 0..GS.max_column_index
          |> Enum.map (fn i ->
               case Board.drop_coin(i, board, @computer) do
                 :error -> 0
                 {:ok, updated_board, player, coord} ->
                   heu = heuristic(coord, updated_board, player)
                   max_move(heu, depth)
               end
             end)

    grab_best_or_random(res)
  end

  def grab_best_or_random(list) do
    if Enum.max(list) == Enum.min(list) do
      Enum.random(list)
    else
      list
      |> Enum.with_index
      |> Enum.sort(fn {valueA, _iA}, {valueB, _iB} ->
           valueA > valueB
         end)
      |> Enum.at(0)
      |> elem(1)
    end
  end


  @doc """
  Max - Returns a single value which represents all child nodes for max player.
  node = %{board: updated_board, terminal: false, coord: coord}
  """
  def max_move(node, depth) do
    if depth <= 0 || node.terminal do
      heu = heuristic(node.coord, node.board, @computer)
      heu.value
      #if node.value < 0, do: 0, else: node.value
    else
      spawn_child_nodes(node.board, @computer)
      |> run_heuristics_on_nodes(@computer)
      |> Enum.reduce(0, fn (n, acc) ->
            max(acc, min_move(n, depth - 1))
         end)
    end
  end

  @doc """
  Min - Returns a single value which represents all child nodes for min player.
  node = %{board: updated_board, terminal: false, coord: coord}
  """
  def min_move(node, depth) do
    if depth <= 0 || node.terminal do
      heu = heuristic(node.coord, node.board, @human)
      heu.value
    else
      spawn_child_nodes(node.board, @human)
      |> run_heuristics_on_nodes(@human)
      |> Enum.reduce(0, fn (n, acc) ->
            min(acc, max_move(n, depth - 1))
         end)
    end
  end

  @doc """
  runs heuristics on a list of values and returns a list of new nodes.
  """
  def run_heuristics_on_nodes(nodes, player) do
    Enum.map(nodes, fn (x) ->
      heuristic(x.coord, x.board, player)
    end)
  end

  @doc """
  Returns the updated board and coord of the move in a map.
  e.g. %{board: board, coord: {x,y}}
  """
  def spawn_child_nodes(board, player) do
    0..GS.max_column_index
    |> Enum.map (fn i ->
      case Board.drop_coin(i, board, player) do
        :error -> %Node{board: board, terminal: true, coord: {i, GS.max_row_index}}
        {:ok, updated_board, _player, coord} -> %Node{board: updated_board, coord: coord}
      end
    end)
  end

  def heuristic(move_coord, board, player) when player == @human do
       case Detector.game_state(board, move_coord, player.colour) do
         {:win, _, _} -> %Node{board: board, coord: move_coord, terminal: true, value: -10}
         _ -> %Node{board: board, coord: move_coord}
       end
  end

  def heuristic(move_coord, board, player) when player == @computer do
       case Detector.game_state(board, move_coord, player.colour) do
         {:win, _, _} -> %Node{board: board, coord: move_coord, terminal: true, value: 10}
         _ -> %Node{board: board, coord: move_coord}
       end
  end

  def get_random() do
     :random.seed(:erlang.system_time)
     :random.uniform(GS.max_column_index)
  end
end

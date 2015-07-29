defmodule Detector do
   alias GameSettings, as: GS

   @type game_state_result :: {Atom.t, Atom.t, Atom.t}

   @spec game_state(List.t, {Integer, Integer}, Atom.t) :: game_state_result
   def game_state(board, coord, colour) do
     detection_results = {
       (vertical_win? board, colour),
       (horizontal_win? board, colour),
       (diagonal_win? board, colour, coord)
     }
     case detection_results do
       {true, _, _} -> {:win, colour, :vertical}
       {false, true, _} -> {:win, colour, :horizontal}
       {false, false, true} -> {:win, colour, :diagonal}
     end

   end

   def vertical_win?(board, colour) do
      Enum.any? board, fn (row) ->
         is_group_a_winner? row, colour
      end
   end

   def horizontal_win?(board, colour) do
      horizontal_board = Board.convert(board, :horizontal)
      Enum.any? board, fn (row) ->
         is_group_a_winner? row, colour
      end
   end

   def diagonal_win?(board, colour, coord) do
      {move_column_index, move_row_index} = coord
      flat_board = List.flatten board
      max_grid_index = (length flat_board) - 1
      starting_index = (move_column_index * GS.no_columns) + move_row_index

      [6,8,-6,-8]
      |> Enum.map fn (i) -> diagonal_indexes(i, starting_index, max_grid_index) end
      |> Enum.map fn (indexes) -> convert_indexes_into_grid_entries(indexes, flat_board) end
      |> Enum.any? fn (row) -> is_group_a_winner?(row, colour) end
   end

   defp is_group_a_winner?(row, colour) do
     winning_count = row |> List.foldl 0, fn (x, acc) ->
       if x == colour, do: acc + 1, else: 0
     end
     case winning_count do
      x when x >= 4 -> true
      _ -> false
     end
   end

   defp convert_indexes_into_grid_entries(indexes, flat_board) do
       Enum.map indexes, fn (i) ->
          elem flat_board, i
       end
   end

   defp diagonal_indexes(increment, current_index, max_grid_index) do
     case current_index do
        i when i < 0 or i > max_grid_index -> []
        i -> i ++ diagonal_indexes(increment, (i + increment), max_grid_index)
     end
   end
end

# FROM MY F# SOLUTION. SEEMS PRETTY ELEGANT WAY OF SOLVING IT
# THE KEY IS TO FLATTEN THE LIST, WHICH IS EASY DONE IN ELIXIR

# let checkForDiagonalWin player (flatGrid:Coin[]) (anchor:int * int) =
#       let startIndex = (fst anchor * GameConstants.COLUMNS) + snd anchor
#       let maxGridIndex = flatGrid.Length - 1
#
#       let indexes startingPos increment =
#           let rec loop accindex =
#               match accindex with
#               | i when i < 0 || i > maxGridIndex -> []
#               | i -> i :: loop (i + increment)
#           loop startingPos
#
#       let convertIndexesIntoGridEntries indexes =
#           indexes |> List.map (fun i -> flatGrid.[i])
#
#       [6;8;-6;-8]
#       |> List.map (indexes startIndex)
#       |> List.map (fun l -> convertIndexesIntoGridEntries l)
#       |> List.exists (fun l -> checkGridGroupForWinner player l)

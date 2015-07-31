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
      Enum.any? horizontal_board, fn (row) ->
         is_group_a_winner? row, colour
      end
   end

   def diagonal_win?(board, colour, coord) do
      {move_column_index, move_row_index} = coord
      flat_board = List.flatten board
      max_grid_index = (length flat_board) - 1
      starting_index = (move_column_index * GS.no_columns) + move_row_index

      [6,8,-6,-8]
      |> get_all_indexes(starting_index, max_grid_index)
      |> indexes_to_grid_entries(flat_board, [])
      |> is_any_row_a_winner?(colour)
   end

   def is_group_a_winner?(row, colour) do
     winning_count = row |> List.foldl 0, fn (x, acc) ->
       if x == colour, do: acc + 1, else: 0
     end
     case winning_count do
      x when x >= 4 -> true
      _ -> false
     end
   end

   def get_all_indexes(increment_list, starting_index, max_grid_index) do
       # each one, 6,8,-6,-8
       Enum.map increment_list, fn (i) -> diagonal_indexes(i, starting_index, max_grid_index, []) end
   end

   def indexes_to_grid_entries([], flat_board, acc), do: acc
   def indexes_to_grid_entries([head|tail], flat_board, acc) do
       updated_acc = acc ++ (Enum.map(head, fn (i) -> elem(flat_board, i) end))
       indexes_to_grid_entries(tail, flat_board, updated_acc)
   end

   def diagonal_indexes(increment, current_index, max_grid_index, acc) do
     case current_index do
        i when i < 0 or i > max_grid_index -> acc
        i ->
          this_acc = acc ++ [i]
          diagonal_indexes(increment, (i + increment), max_grid_index, this_acc)
     end
   end

   defp is_any_row_a_winner?(board, colour) do
      Enum.any? board, fn (row) -> is_group_a_winner?(row, colour) end
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

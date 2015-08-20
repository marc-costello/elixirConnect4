defmodule Detector do
   alias GameSettings, as: GS

   @type game_state_result :: {Atom.t, Atom.t, Atom.t}

   @spec game_state(List.t, {Integer, Integer}, Atom.t) :: game_state_result
   def game_state(board, coord, colour) do
     detection_results = {
       (vertical_win? board, colour, coord),
       (horizontal_win? board, colour, coord),
       (diagonal_win? board, colour, coord),
       (draw? board)
     }
     case detection_results do
       {true, _, _, _} -> {:win, colour, :vertical}
       {false, true, _, _} -> {:win, colour, :horizontal}
       {_, _, true, _} -> {:win, colour, :diagonal}
       {false, false, false, true} -> {:draw}
       {false, false, false, false} -> {:none}
     end
   end

   def vertical_win?(board, colour, {x, _y}) do
      Enum.at(board, x) |> is_group_a_winner?(colour)
   end

   def horizontal_win?(board, colour, {_x, y}) do
      Board.convert(board, :horizontal)
      |> Enum.at(y)
      |> is_group_a_winner?(colour)
   end

   def diagonal_win?(board, colour, coord) do
      {move_column_index, move_row_index} = coord
      flat_board = List.flatten board
      max_grid_index = (length flat_board) - 1
      starting_index = (move_column_index * GS.max_column_index) + move_row_index

      [7,9,-7,-9]
      |> get_all_indexes(starting_index, max_grid_index)
      |> indexes_to_grid_entries(flat_board, [])
      |> is_any_row_a_winner?(colour)
   end

   def draw?(board) do
     draw =
       board
       |> List.flatten
       |> Enum.any? &(&1 == :empty)
     !draw
   end

   def is_group_a_winner?(row, colour) do
     winning_count = row |> List.foldl 0, fn (entry, acc) ->
       case {entry, acc} do
         {_, 4} -> 4
         {^colour, _} -> acc + 1
         {_, _} -> 0
       end
     end
     winning_count >= 4
   end

   def get_all_indexes(increment_list, starting_index, max_grid_index) do
       Enum.map increment_list, fn (i) -> diagonal_indexes(i, starting_index, max_grid_index, []) end
   end

   def indexes_to_grid_entries([], flat_board, acc), do: acc
   def indexes_to_grid_entries([head|tail], flat_board, acc) do
       updated_acc = acc ++ [(Enum.map(head, fn (i) -> Enum.at(flat_board, i) end))]
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

   def is_any_row_a_winner?(board, colour) do
      Enum.any? board, fn (row) -> is_group_a_winner?(row, colour) end
   end
end

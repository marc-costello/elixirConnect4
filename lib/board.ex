defmodule Board do
   alias GameSettings, as: GS

   def create_new() do
      aRow = fn -> for n <- 1..GS.no_rows, do: :empty end
      for _ <- 1..GS.no_columns, do: aRow.()
   end

   def is_blank?(board) do
      List.flatten(board) |> Enum.all? &(&1 == :empty)
   end

   def drop_coin(column, board, player) do
      #case can_drop_coin? board, column do
         #true ->
         #false ->
      #end
      :error
   end

   def can_drop_coin?(board, column) do
      columnList = board |> Enum.at column
      Enum.any? columnList, fn(row_item) -> row_item == :empty end
   end

   def make_move(board, {colIndex, rowIndex}, colour) do
      new_row = board
       |> Enum.at(colIndex)
       |> List.replace_at(rowIndex, colour)
      List.replace_at(board, colIndex, new_row)
   end
end

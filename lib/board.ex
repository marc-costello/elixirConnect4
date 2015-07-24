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
      case can_drop_coin board, column do
         false -> :error
         {:ok, emptyRowIndex} ->
            updatedBoard = make_move(board, {column, emptyRowIndex}, player.colour)
            {:ok, updatedBoard, player, {1,0}}
      end
   end

   def can_drop_coin(board, column) do
      case board |> Enum.at column do
         nil -> false
         columnList ->
            availableIndex =
               columnList
               |> Enum.with_index
               |> Enum.find fn({item, i}) -> item == :empty end
            if availableIndex == nil, do: false, else: {:ok, elem(availableIndex, 1)}
      end
   end

   def make_move(board, {colIndex, rowIndex}, colour) do
      new_row = board
       |> Enum.at(colIndex)
       |> List.replace_at(rowIndex, colour)
      List.replace_at(board, colIndex, new_row)
   end
end

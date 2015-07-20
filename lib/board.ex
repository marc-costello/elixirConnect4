defmodule Board do

   def create_new() do
      aRow = fn -> for n <- 1..6, do: :empty end
      for _ <- 1..7, do: aRow.()
   end

   def is_blank?(board) do
      List.flatten(board) |> Enum.all? &(&1 == :empty)
   end
end

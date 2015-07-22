defmodule Board do

   def create_new() do
      aRow = fn -> for n <- 1..6, do: :empty end
      for _ <- 1..7, do: aRow.()
   end

   def is_blank?(board) do
      List.flatten(board) |> Enum.all? &(&1 == :empty)
   end

   def drop_coin(board, player, column) do
      #case can_drop_coin? board, column do
         #true ->
         #false ->
      #end
      :error
   end

   def can_drop_coin?(board, column) do

   end
end

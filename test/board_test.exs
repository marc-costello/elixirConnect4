defmodule BoardTests do
   use ExUnit.Case

   test "a connect4 board should have 7 columns" do
      board = Board.create_new()
      columnCount = length board
      assert columnCount == 7
   end

   test "a connect4 board should have 6 rows" do
      board = Board.create_new()
      rowCount =
         board
         |> List.first
         |> length
      assert rowCount == 6
   end

   test "a board should be initialised full of :empty" do
      board = Board.create_new()
      allEmpties =
         board
         |> List.flatten
         |> Enum.all? &(&1 == :empty)
      assert allEmpties
   end

   test "a given board empty/blank" do
      board = Board.create_new()
      assert Board.is_blank?(board) == true
   end

end

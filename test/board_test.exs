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

   test "drop a coin on a given column using the players colour" do
      board = Board.create_new()
      player = %Player{type: :human, colour: :red}

      {:ok, move} = Board.drop_coin 2, board, player
      assert move == {1,0}
   end

   test "given a board and a valid column number, can a coin be dropped? should return true" do
       board = Board.create_new()
       assert Board.can_drop_coin?(board, 1)
   end

   test "given a board and an invalid column number, can a coin be dropped should return false" do
       board = Board.create_new()
       assert Board.can_drop_coin?(board, 99) == false
   end

   test "given a board with a full column, can a coin be dropped should return false" do
       board = Board.create_new()
       columnIndex = 0
       fullColumn = for _ <- 1..6, do: :red
       updatedBoard = board |> List.replace_at(columnIndex, fullColumn)
       assert Board.can_drop_coin?(updatedBoard, columnIndex) == false
   end
end

defmodule DetectorTests do
  use ExUnit.Case
  require Integer
  alias GameSettings, as: GS

  test "detect a horizontal win" do
    row = fn -> [:red, :empty, :empty, :empty, :empty, :empty] end
    winning_board = for _ <- 1..GS.no_columns, do: row.()
    assert Detector.game_state(winning_board, {1,0}, :red) == {:win, :red, :horizontal}
  end

  test "detect a vertical win" do
     board = Board.create_new()
     winning_row = for _ <- 1..GS.no_rows, do: :red
     winning_board = List.replace_at board, 1, winning_row

     assert Detector.game_state(winning_board, {1, 3}, :red) == {:win, :red, :vertical}
  end

  test "detect a diagonal win" do
    board = Board.create_new()
    winning_board = Enum.reduce([0,1,2,3], board, fn(i, accBoard) -> Board.make_move(accBoard, {i, i}, :red) end)
    assert Detector.diagonal_win?(winning_board, :red, {3, 3})
    #assert Detector.game_state(winning_board, {3, 3}, :red) == {:win, :red, :diagonal}
  end

  test "detect a draw" do
    draw_row =
       fn -> for x <- 1..GS.no_rows do
           if Integer.is_even(x), do: :red, else: :yellow
       end
    end
    draw_board = for x <- 1..GS.no_columns do
       if Integer.is_even(x), do: draw_row.(), else: Enum.reverse(draw_row.())
    end
    assert Detector.game_state(draw_board, {GS.max_column_index, GS.max_row_index}, :red) == {:draw}
  end

  test "given a list of moves, detect a win" do
    winning_row = [:empty, :red, :red, :red, :red, :empty]
    assert Detector.is_group_a_winner? winning_row, :red
  end

  test "no winner or draw detected return :none" do
    board = Board.create_new()
    assert Detector.game_state(board, {0, 0}, :red) == {:none}
  end

  test "indexes_to_grid_entries should return all entries in the index list." do
     indexes = [[0,1,2], [3,4]]
     collection = ["0", "1", "2", "3", "4"]
     results = Detector.indexes_to_grid_entries(indexes, collection, [])
     assert results == [["0", "1", "2"], ["3", "4"]]
  end

  test "get_all_indexes should return a list" do
      max_index = GS.max_row_index * GS.max_column_index
      assert Detector.get_all_indexes([6,8,-6,-8], 0, max_index) |> is_list
  end

  test "is_any_row_a_winner? should return true if any list is a connect4" do
      assert Detector.is_any_row_a_winner? [[:red,:red,:red,:red,:empty],[:empty, :red, :red, :yellow]], :red
  end
end

defmodule AiTests do
  use ExUnit.Case
  alias GameSettings, as: GS

  test "the computer can calculate a valid move on the board" do
     board = Board.create_new()
     col = Ai.calculate_best_move(board, :yellow)
     assert Enum.any? 0..GS.max_column_index, &(&1 == col)
  end

  test "the computer always tries to bunch moves together" do
    board = Board.create_new()
    row = for n <- 1..GS.no_rows do
      if n < 3, do: :yellow, else: :empty
    end
    updated_board = List.replace_at(board, 2, row)
    assert Ai.calculate_best_move(updated_board, :yellow) == 2
  end

  test "we can call calculate best move on an empty board and it return a valid index" do
    board = Board.create_new()
    result = Ai.calculate_best_move board, :yellow
    assert result >= 0 && result <= GS.max_column_index
  end
end

defmodule AiTests do
  use ExUnit.Case
  alias GameSettings, as: GS

  test "the computer can calculate a valid move on the board" do
     board = Board.create_new()
     col = Ai.calculate_best_move(board, :yellow)
     assert Enum.any? 0..GS.max_column_index, &(&1 == col)
  end

  test "we can call calculate best move on an empty board and it return a valid index" do
    board = Board.create_new()
    result = Ai.calculate_best_move board, :yellow
    assert result >= 0 && result <= GS.max_column_index
  end

  test "wont recommend a column with no empty spaces left" do
      full_row = fn -> for _ <- 1..GS.no_rows, do: :red end
      empty_row = fn -> for _ <- 1..GS.no_rows, do: :empty end
      board =
         for _ <- 1..GS.no_columns, do: full_row.()
         |> List.replace_at(1, empty_row.())

      assert Ai.calculate_best_move(board, :yellow) == 1
  end

  test "the computer always picks a winning move where possible" do
      possible_win_row = fn -> for n <- 1..GS.no_rows do
            if n <= 3, do: :yellow, else: :empty
         end
      end
      empty_row = fn -> for _ <- 1..GS.no_rows, do: :red end
      board =
         for _ <- 1..GS.no_columns, do: empty_row.()
         |> List.replace_at(2, possible_win_row.())

      assert Ai.calculate_best_move(board, :yellow) == 2
  end
end

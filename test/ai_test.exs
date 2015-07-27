defmodule AiTests do
  use ExUnit.Case
  alias GameSettings, as: GS

  test "computer always tries to bunch moves together" do
    board = Board.create_new()
    row = for n <- 1..GS.no_rows do
      if n < 3, do: :yellow, else: :empty
    end
    updated_board = List.replace_at(board, 0, row)
    assert Ai.calculate_best_move(updated_board, :yellow) == {0, 2}
  end
end

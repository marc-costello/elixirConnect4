defmodule AiTests do
  use ExUnit.Case
  require Integer
  alias GameSettings, as: GS

  # Ai.calculate_best_move(Board.create_new(), 4)

  # mod_board = Board.create_new() |> List.replace_at(1, [:yellow,:yellow,:yellow,:empty,:empty,:empty])
  # Ai.calculate_best_move(mod_board, 3)

  # PSEUDOCODE FOR MINIMAX
  # function minimax(node, depth, maximizingPlayer)
  #     if depth = 0 or node is a terminal node
  #         return the heuristic value of node
  #     if maximizingPlayer
  #         bestValue := -∞
  #         for each child of node
  #             val := minimax(child, depth - 1, FALSE)
  #             bestValue := max(bestValue, val)
  #         return bestValue
  #     else
  #         bestValue := +∞
  #         for each child of node
  #             val := minimax(child, depth - 1, TRUE)
  #             bestValue := min(bestValue, val)
  #         return bestValue
  #
  # (* Initial call for maximizing player *)
  # minimax(origin, depth, TRUE)

  @computer %Player{type: :computer, colour: :yellow}
  @human %Player{type: :human, colour: :red}

  test "get all states from the board" do
    board = Board.create_new()
    states = Ai.get_states(board, @computer)

    assert length(states) == GS.no_columns
  end

  test "heuristic with no computer winner should return no value and not terminal" do
    {:ok, board, _player, _coord} = Board.drop_coin(0, Board.create_new(), @computer)
    heuristic_result = Ai.heuristic({0, 0}, board, @computer)

    assert heuristic_result == %{terminal: false, value: 0}
  end

  test "heuristic with a computer winner should return terminal true with a value of 10" do
    board = Board.create_new()
    winning_row = [:yellow,:yellow,:yellow,:yellow,:empty,:empty]
    winning_board = List.replace_at board, 0, winning_row
    heuristic_result = Ai.heuristic({0, 3}, winning_board, @computer)

    assert heuristic_result == %{terminal: true, value: 10}
  end

  test "heuristic with a draw should return terminal true with a value of 0" do
    draw_row =
       fn -> for x <- 1..GS.no_rows do
           if Integer.is_even(x), do: :red, else: :yellow
       end
    end
    draw_board = for x <- 1..GS.no_columns do
       if Integer.is_even(x), do: draw_row.(), else: Enum.reverse(draw_row.())
    end

    heuristic_result = Ai.heuristic({GS.max_column_index, GS.max_row_index}, draw_board, @human)
    assert heuristic_result == %{terminal: true, value: 0}
  end

  test "heuristic with no human winner should return terminal false and a value of 0" do
    {:ok, board, _player, _coord} = Board.drop_coin(0, Board.create_new(), @human)
    heuristic_result = Ai.heuristic({0, 0}, board, @human)

    assert heuristic_result == %{terminal: false, value: 0}
  end

  test "heuristic with a human winner should return terminal true and a value of -10" do
    board = Board.create_new()
    winning_row = [:red,:red,:red,:red,:empty,:empty]
    winning_board = List.replace_at board, 0, winning_row
    heuristic_result = Ai.heuristic({0, 3}, winning_board, @human)

    assert heuristic_result == %{terminal: true, value: -10}
  end
end

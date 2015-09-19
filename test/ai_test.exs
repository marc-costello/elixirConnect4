defmodule AiTests do
  use ExUnit.Case
  require Integer
  alias GameSettings, as: GS

  # MinMax (GamePosition game) {
  #   return MaxMove (game);
  # }
  #
  # MaxMove (GamePosition game) {
  #   if (GameEnded(game)) {
  #     return EvalGameState(game);
  #   }
  #   else {
  #     best_move < - {};
  #     moves <- GenerateMoves(game);
  #     ForEach moves {
  #        move <- MinMove(ApplyMove(game));
  #        if (Value(move) > Value(best_move)) {
  #           best_move < - move;
  #        }
  #     }
  #     return best_move;
  #   }
  # }
  #
  # MinMove (GamePosition game) {
  #   best_move <- {};
  #   moves <- GenerateMoves(game);
  #   ForEach moves {
  #      move <- MaxMove(ApplyMove(game));
  #      if (Value(move) > Value(best_move)) {
  #         best_move < - move;
  #      }
  #   }
  #
  #   return best_move;
  # }

  @computer %Player{type: :computer, colour: :yellow}
  @human %Player{type: :human, colour: :red}

  test "get all states from the board" do
    board = Board.create_new()
    states = Ai.get_child_nodes(board, @computer)

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

  test "get all immediately possible states for a board" do
    board = Board.create_new()
    all_states = Ai.get_child_nodes(board, @computer)

    assert Enum.all?(all_states, fn %{board: b, coord: {x,y}} ->
      res = b |> Enum.at(x) |> Enum.at(y)
      res == :yellow
    end)
  end

  test "running minimax on a particular node should return the combined values" do
    yellow_row = [:yellow,:yellow,:yellow,:empty,:empty,:empty]
    red_row = [:red,:red,:red,:empty,:empty,:empty]
    board =
      List.replace_at(Board.create_new(), 1, yellow_row)
      |> List.replace_at(2, red_row)
    value = Ai.calculate_best_move(board, 1)

    assert value == [0,10,-10,0,0,0,0]
  end
end

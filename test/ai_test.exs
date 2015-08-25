defmodule AiTests do
  use ExUnit.Case
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

  test "assign a value to each state" do
     board = Board.create_new()
     states = Ai.get_states(board, @computer)
     assigned =
  end

  test "return the highest minimax branch value" do

  end
end

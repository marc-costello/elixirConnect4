defmodule AiTests do
  use ExUnit.Case
  alias GameSettings, as: GS

  # Ai.calculate_best_move(Board.create_new(), %Player{type: :computer, colour: :yellow}, 4)

  # mod_board = Board.create_new() |> List.replace_at(1, [:yellow,:yellow,:yellow,:empty,:empty,:empty])
  # Ai.calculate_best_move(mod_board, %Player{type: :computer, colour: :yellow}, 3)

  @computer %Player{type: :computer, colour: :yellow}
  @human %Player{type: :human, colour: :red}

  test "get all states from the board" do
    board = Board.create_new()
    states = Ai.get_states(board, @computer)

    assert length(states) == GS.no_columns
  end

  test "each state is one move dropped on the original board" do
    board = Board.create_new()
    states = Ai.get_states(board, @computer)
    test_row = [:yellow,:empty,:empty,:empty,:empty,:empty]
    
  end

  test "assign a number to each state" do

  end

  test "return the highest minimax branch value" do

  end
end

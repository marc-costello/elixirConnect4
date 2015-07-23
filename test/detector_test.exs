defmodule DetectorTests do
  use ExUnit.Case, GameSettings
  require Integer

  test "detect a horizontal win" do
    board = Board.create_new()
    row = fn ->
      for n <- 1..6 do
         if n == 1, do: :red, else: :empty
      end
    end
    winning_board = for _ <- 1..no_columns, do: row.()

    assert Detector.game_state(winning_board, {}, :red) == {:win, :red, :horizontal}
  end

  test "detect a vertical win" do
     board = Board.create_new()
     winning_row = for _ <- 1..no_rows, do: :red
     winning_board = List.replace_at board, 1, winning_row

     assert Detector.game_state(winning_board, {1, 3}, :red) == {:win, :red, :vertical}
  end

  test "detect a diagonal win" do
    board = Board.create_new()
    #winning_grid = [0..3] |> List.fold (fun accGrid i -> Grid.makeMove accGrid ((i,i), Player(Red))) blankGrid
    winning_board = [0..3] |> Enum.reduce(board, fn(i, accBoard) -> Board.make_move(accBoard, {i, i}, :red) end)
    assert Detector.game_state(winning_board, {3, 3}, :red) == {:win, :red, :diagonal}
  end

  test "detect a draw" do
    draw_row = fn -> for x <- 1..no_rows do
           if Integer.is_even(x), do: :red, else: :yellow
       end
    end
    draw_board = for x <- 1..no_columns do
       if Integer.is_even(x), do: draw_row.(), else: Enum.reverse(draw_row.())
    end
    assert Detector.game_state(draw_board, {6, 5}, :red) == {:draw}
  end
end

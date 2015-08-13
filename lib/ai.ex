defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, colour) do
     # for each possible move, (column)
     1..GS.no_columns
     |> Enum.map fn (i) -> column_rank(i, board, colour) end
  end

  defp column_rank(columnIndex, board, colour) do
     state_process_id = Agent.start_link(fn -> 0 end)
     case loop(board, colour) do
      {:continue, updated_board, nextColour} -> loop(updated_board, nextColour, state_process_id, column_index)
      {:end} ->
         rank = Agent.get(state_process_id, &(&1))
         Agent.stop(state_process_id)
         rank
    end
  end

  defp loop(board, :yellow, state_process_id) do
     # returns
     #{:continue, updated_board, nextColour} or
     # {:end}

     # drop coin on board
     case Board.drop_coin(column_index, board, %Player {type = :computer, colour = :yellow}) do
        :error -> 
        {:ok, updatedBoard, player, {column, emptyRowIndex}} ->
     end
     # get game_state
     # update state depending on game_state
     # call loop until we can no longer move, win or draw
  end

  defp loop(board, :red, state_process_id) do
     # returns
     #{:continue, updated_board, nextColour} or
     # {:end}

  end

  def get_random() do
     :random.seed(:erlang.now)
     :random.uniform(GS.max_column_index)
  end
end

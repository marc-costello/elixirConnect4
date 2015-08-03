defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, colour) do
     horizontal_board = Board.convert board, :horizontal

     vertical_counts =
         board
         |> counts_of_colour_with_index(colour)
         |> sort

     horizontal_counts =
        horizontal_board
        |> counts_of_colour_with_index(colour)
        |> sort

     most_suited =
         highest_chance(vertical_counts, horizontal_counts)
         |> get_final_recommended_row_index
  end

  defp counts_of_colour_with_index(board, colour) do
     Enum.map(Enum.with_index(board), fn({row, i}) ->
        {Enum.count(row, &(&1 == colour)), i}
     end)
  end

  defp sort(counts) do
      Enum.sort(counts, fn ({a, _}, {b, _}) -> a > b end)
  end

  defp highest_chance(vertical_counts, horizontal_counts) do
     {vc, vci} = Enum.at(vertical_counts, 0)
     {hc, hci} = Enum.at(horizontal_counts, 0)

     case vc do
         x when x >= hc -> {:vertical, vci}
         x -> {:horizontal, hci}
     end
  end

  defp get_final_recommended_row_index({alignment, index}) when alignment == :vertical do
     index
  end

  defp get_final_recommended_row_index({alignment, index}) when alignment == :horizontal do

  end

  def get_random() do
     :random.seed(:erlang.now)
     :random.uniform(GS.max_column_index)
  end
end

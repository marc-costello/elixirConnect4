defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, player, depth) do
     # start the loop
     0..GS.max_column_index
     |> Enum.map fn i ->
       {i, loop(board, player, 0, depth)}
     end
  end

  @doc """
    acc needs to be a list of all the ranks
  """
  def loop(board, player, acc_rank, depth) do
    case depth do
      0 -> acc_rank
      _ ->
        new_depth = depth - 1
        next_player = Player.next_player(player.type)
        0..GS.max_column_index
        |> Enum.reduce fn (i, acc) ->
          {updated_board, rank} = round(i, board, player)
          new_acc = acc + rank
          loop(updated_board, next_player, new_acc, new_depth)
        end
    end
  end

  def round(column, board, player) when player == %Player{type: :human, colour: :red} do
      IO.puts "human round - col = #{column}"
      {:ok, updated_board, player, coord} = Board.drop_coin(column, board, player)
      case Detector.game_state(updated_board, coord, player.colour) do
        {:win, _, _} -> {updated_board, -1000}
        _ -> {updated_board, 0}
      end
  end

  def round(column, board, player) when player == %Player{type: :computer, colour: :yellow} do
      IO.puts "computer round - col = #{column}"
      {:ok, updated_board, player, coord} = Board.drop_coin(column, board, player)
      case Detector.game_state(updated_board, coord, player.colour) do
        {:win, _, _} -> {updated_board, 1000}
        _ -> {updated_board, 0}
      end
  end

  def get_random() do
     :random.seed(:erlang.now)
     :random.uniform(GS.max_column_index)
  end
end

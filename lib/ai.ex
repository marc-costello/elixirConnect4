defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, player, depth) do
     # start the loop
     0..GS.max_column_index
     |> Enum.map fn i ->
        {i, generate_states(board, player, 0)}
     end
  end

  def generate_states(board, player, base_acc) do
    IO.puts "in generate_states beginning"
    next_player = Player.next_player(player.type)
    mapped =
       0..GS.max_column_index
       |> Enum.map fn i -> round(i, board, player) end
    IO.puts "completed mapping rounds"
    Enum.reduce mapped, base_acc, fn (entry, acc) ->
       case entry do
         {:end, new_board, rank} ->
            IO.puts "END with rank : #{rank}"
            acc + rank
         {:continue, new_board, rank} -> generate_states(new_board, next_player, acc + rank)
       end
     end
  end

  def round(column, board, player) when player == %Player{type: :human, colour: :red} do
      case Board.drop_coin(column, board, player) do
        :error -> {:end, board, 0}
        {:ok, updated_board, player, coord} ->
          case Detector.game_state(updated_board, coord, player.colour) do
            {:win, _, _} -> {:end, updated_board, -1000}
            _ -> {:continue, updated_board, 0}
          end
      end
  end

  def round(column, board, player) when player == %Player{type: :computer, colour: :yellow} do
      case Board.drop_coin(column, board, player) do
        :error -> {:end, board, 0}
        {:ok, updated_board, player, coord} ->
          case Detector.game_state(updated_board, coord, player.colour) do
            {:win, _, _} -> {:end, updated_board, 1000}
            _ -> {:continue, updated_board, 0}
          end
      end
  end

  def get_random() do
     :random.seed(:erlang.now)
     :random.uniform(GS.max_column_index)
  end
end

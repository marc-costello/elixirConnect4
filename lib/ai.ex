defmodule Ai do
  alias GameSettings, as: GS

  def calculate_best_move(board, player, depth) do
    get_states(board, player)
  end

  def get_states(board, player) do
    0..GS.max_column_index
    |> Enum.map fn i ->
      case Board.drop_coin(i, board, player) do
        :error -> {board, 0}
        {:ok, updated_board, player, coord} -> {updated_board, coord}
      end
    end
  end

  def minimax(states) do

  end

  def generate_states(board, player, base_acc, depth) do
    case depth do
       0 -> base_acc
       _ ->
          mapped =
             0..GS.max_column_index
             |> Enum.map fn i -> round(i, board, player) end
          get_recursive_states_function = fn (board, player, acc, depth) ->
             fn ->  end
          end
          Enum.reduce mapped, base_acc, fn (entry, acc) ->
             case entry do
               {:end, _new_board, rank} -> acc + rank
               {:continue, new_board, rank} -> generate_states(new_board, Player.next_player(player.type), (acc + rank), (depth - 1))
             end
           end
    end
  end

  def round(column, board, player) when player == %Player{type: :human, colour: :red} do
      case Board.drop_coin(column, board, player) do
        :error -> {:end, board, 0}
        {:ok, updated_board, player, coord} ->
          case Detector.game_state(updated_board, coord, player.colour) do
            {:win, _, _} ->
               IO.puts "end state at #{coord} for player: #{player}"
               {:end, updated_board, -1000}
            {:draw} -> {:end, updated_board, -100}
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
            {:draw} -> {:end, updated_board, 100}
            _ -> {:continue, updated_board, 0}
          end
      end
  end

  def get_random() do
     :random.seed(:erlang.now)
     :random.uniform(GS.max_column_index)
  end
end

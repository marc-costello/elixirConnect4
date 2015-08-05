defmodule ElixirConnect4 do

   def start() do
      {board, player} = Game.start_new()
      game_loop(board, player)
   end

   def game_loop(board, player) do
       Renderer.render(board)

       case Game.take_turn(board, player) do
          {:error, msg} ->
             IO.puts msg
             game_loop(board, player)
          {:ok, updated_board, player_which_just_moved, coord} ->
             if handle_game_state(updated_board, coord, player_which_just_moved.colour) == {:none} do
                game_loop(updated_board, next_player(player_which_just_moved.type))
             end
       end
   end

   defp next_player(last_player_type) do
      case last_player_type do
         :human -> %Player{type: :computer, colour: :yellow}
         :computer -> %Player{type: :human, colour: :red}
      end
   end

   defp handle_game_state(board, coord, colour) do
       case Detector.game_state(board, coord, colour) do
           {:win, colour, direction} -> end_game(board, "WINNER! - #{to_string(colour)} did it with a #{to_string(direction)} connect4")
           {:draw} -> end_game(board, "DRAW")
           x -> x
       end
   end

   defp end_game(board, msg) do
      Renderer.render board
      IO.puts msg
   end
end

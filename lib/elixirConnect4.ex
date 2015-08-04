defmodule ElixirConnect4 do
   alias GameSettings, as: GS

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
          {:ok, updated_board, player_which_just_moved, _coord} -> game_loop(updated_board, next_player(player_which_just_moved.type))
       end
   end

   defp next_player(last_player_type) do
      case last_player_type do
         :human -> %Player{type: :computer, colour: :yellow}
         :computer -> %Player{type: :human, colour: :red}
      end
   end
end

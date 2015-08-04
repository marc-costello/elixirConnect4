defmodule ElixirConnect4 do
   alias GameSettings, as: GS

   def start() do
      {board, player} = Game.start_new()

      IO.puts "Select a column from 1 #{GS.no_columns}"
      game_loop(board, player)
   end

   def game_loop(board, player) do
       Renderer.render(board)

       case Game.take_turn(board, player) do
          {:error, msg} ->
             IO.puts msg
             game_loop(board, player)
          {:ok, updated_board, _p, _coord} -> game_loop(updated_board, %Player{type: :computer, colour: :yellow})
       end
   end
end

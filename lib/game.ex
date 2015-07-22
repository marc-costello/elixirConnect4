defmodule Game do
   def start_new() do
      { Board.create_new(), %Player{type: :human, colour: :red} }
   end

   def take_turn(board, player) do
      input = Player.receive_input()
      #case Board.drop_coin column do
         #:error ->
         #{:ok, move} ->
      #end
   end
end

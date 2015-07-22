defmodule Game do
   def start_new() do
      { Board.create_new(), %Player{type: :human, colour: :red} }
   end

   def take_turn(board, player) do
     {:ok, {1,1}}
   end
end

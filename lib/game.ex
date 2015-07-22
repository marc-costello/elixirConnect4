defmodule Game do
   def start_new() do
      { Board.create_new(), %Player{type: :human, colour: :red} }
   end

   def take_turn(board, player) do
      case player.type do
        :human -> take_human_turn board, player
        :computer -> take_computer_turn board, player
      end
   end

   defp take_human_turn(board, player) do
     Player.receive_input()
     |> Board.drop_coin board, player
   end

   defp take_computer_turn(board, player) do
     # do computer stuff..
   end

   defp column_index_from_input(input) do
     input - 1
   end
end

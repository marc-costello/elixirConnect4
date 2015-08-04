defmodule Game do
  alias GameSettings, as: GS

   def start_new() do
     board = Board.create_new()
     { board, %Player{type: :human, colour: :red} }
   end

   @doc """
    on error returns: {:error, msg} \n
    on success returns: {:ok, board, player, coord}
   """
   def take_turn(board, player) do
      case player.type do
        :human -> take_human_turn board, player
        :computer -> take_computer_turn board, player
      end
   end

   defp take_human_turn(board, player) do
     no_columns = GS.no_columns
     case Player.receive_input() do
       x when x > no_columns or x < 1 ->
         {:error, "That is out of range, please try again\n"}
       x -> drop_coin_or_tell_user_of_failure(x, board, player)
     end
   end

   defp take_computer_turn(board, player) do
    result =
       Ai.calculate_best_move(board, player.colour)
       |> Board.drop_coin(board, player)

     case result do
       :error -> IO.puts "error happened while taking computer turn."
       success -> success
     end
   end

   defp drop_coin_or_tell_user_of_failure(column, board, player) do
     case Board.drop_coin (column - 1), board, player do
       :error ->
         take_turn board, player
       success -> success
     end
   end
end

defmodule GameTests do
   use ExUnit.Case, async: false
   import Mock

   test "beginning a new game generates a blank board" do
      {board, _player} = Game.start_new()
      assert (Board.is_blank? board) == true
   end

   test "beginning a new game returns the human player" do
      {_board, player} = Game.start_new()
      assert player.type == :human
   end

   test "human turn waits for user input" do
      {board, _player} = Game.start_new()
      {:ok, move} = Game.take_turn board, %Player {type: :human, colour: :red}
      assert move == {1, 1}
   end

   test "computer turn automatically plays" do
      {board, _player} = Game.start_new()
      {status, move} = Game.take_turn board, %Player {type: :computer, colour: :yellow}
      assert status == :ok
   end

   test_with_mock "when an invalid input is given, status returns :error and an appropriate message",
      IO, [gets: fn(_prompt) -> "notvalid\n" end] do
      {board, _player} = Game.start_new()
      {:error, msg} = Game.take_turn board, %Player {type: :human, colour: :red}
      assert msg == "That is not a valid input, please try again\n"
   end

   test_with_mock "when an out of range int is given, status returns :error and an appropriate message",
      IO, [gets: fn(_prompt) -> "8\n" end] do
      {board, _player} = Game.start_new()
      {:error, msg} = Game.take_turn board, %Player {type: :human, colour: :red}
      assert msg == "That is out of range, please try again\n"
   end
end

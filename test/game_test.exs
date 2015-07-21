defmodule GameTests do
   use ExUnit.Case

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

   test "when a move cannot be made status returns :error" do
      {board, _player} = Game.start_new()
      {status, _msg} = Game.take_turn board, %Player {type: :human, colour: :red}
      assert status == :error
   end

end

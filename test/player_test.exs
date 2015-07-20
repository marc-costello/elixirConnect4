defmodule PlayerTests do
   use ExUnit.Case
   import Mock

   test "being able to get input from the user via IO" do
      with_mock IO, [:gets, fn -> # something]
      input = Player.receive()
   end

end

defmodule PlayerTests do
   use ExUnit.Case, async: false
   import Mock

   test "being able to get input from the user via IO" do
      with_mock IO, [gets: fn(_prompt) -> "1\n" end] do
         result = IO.gets("say something: ")
         assert result == "1\n"
      end
   end

end

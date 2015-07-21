defmodule Player do
   defstruct [:type, :colour]

   def receive_input(prompt // "Select a column 1-8") do
       input = IO.gets(prompt) |> String.replace "\n", ""
       {inputInt, _rem} = Integer.parse input
       inputInt
   end
end

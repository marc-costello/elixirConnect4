defmodule Player do
   defstruct [:type, :colour]

   def receive_input(prompt \\ "Select a column 1-8: ") do
       input = IO.gets(prompt) |> String.replace "\n", ""
       case Integer.parse input do
         :error ->
           print_not_valid_input(input)
           receive_input()
         {inputInt, _rem} -> inputInt
       end
   end

   defp print_not_valid_input(input) do
     IO.puts "#{input} is not a valid input"
   end
end

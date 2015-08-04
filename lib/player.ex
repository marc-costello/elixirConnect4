defmodule Player do
   defstruct [:type, :colour]

   @doc """
      If the input cannot be parsed it will make another attempt until we get an Integer parsable result
      returns: whole a integer
   """
   def receive_input(prompt \\ "Select a column 1-7: ") do
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

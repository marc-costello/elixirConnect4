defmodule Detector do

   @type game_state_result :: {Atom.t, Atom.t, Atom.t}

   @spec game_state(List.t, Atom.t, {Integer, Integer}) :: game_state_result
   def game_state(board, colour, coord) do
     board
     |> vertical_win? player, colour
     |> horizontal_win? player, colour
     |> diagonal_win? player, colour, coord
   end

   defp is_row_a_winner?(row, colour) do
     winning_count = row |> List.foldl 0, fn (x, acc) ->
       if x == colour, do: acc + 1, else: 0
     end
     case winning_count do
      x when x >= 4 -> true
      _ -> false
     end
   end
end

# FROM MY F# SOLUTION. SEEMS PRETTY ELEGANT WAY OF SOLVING IT
# THE KEY IS TO FLATTEN THE LIST, WHICH IS EASY DONE IN ELIXIR

# let checkForDiagonalWin player (flatGrid:Coin[]) (anchor:int * int) =
#       let startIndex = (fst anchor * GameConstants.COLUMNS) + snd anchor
#       let maxGridIndex = flatGrid.Length - 1
#
#       let indexes startingPos increment =
#           let rec loop accindex =
#               match accindex with
#               | i when i < 0 || i > maxGridIndex -> []
#               | i -> i :: loop (i + increment)
#           loop startingPos
#
#       let convertIndexesIntoGridEntries indexes =
#           indexes |> List.map (fun i -> flatGrid.[i])
#
#       [6;8;-6;-8]
#       |> List.map (indexes startIndex)
#       |> List.map (fun l -> convertIndexesIntoGridEntries l)
#       |> List.exists (fun l -> checkGridGroupForWinner player l)

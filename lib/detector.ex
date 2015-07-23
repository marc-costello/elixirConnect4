defmodule Detector do
   def game_state(board, {colIndex, rowIndex}) do

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

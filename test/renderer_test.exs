defmodule RendererTests do
   use ExUnit.Case

   test "renderer converts player colour into appropriate symbol" do
     assert Renderer.convert_colour_to_symbol(:red) == "R"
     assert Renderer.convert_colour_to_symbol(:yellow) == "Y"
     assert Renderer.convert_colour_to_symbol(:empty) == "o"
   end
end

defmodule Renderer do
  def render(board) do
    Enum.each(board, fn(row) -> render_row(row) end)
    IO.puts ""
  end

  def render_row(row) do
    row_string = Enum.reduce(row, "", fn(entry, acc) ->
      symbol = convert_colour_to_symbol(entry)
      acc <> "[#{symbol}] "
    end)
    IO.puts row_string
  end

  def convert_colour_to_symbol(colour) do
    case colour do
      :red -> "R"
      :yellow -> "Y"
      :empty -> "x"
    end
  end
end

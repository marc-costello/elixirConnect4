defmodule Renderer do
  def render(board) do
    horizontal_board = Enum.reverse Board.convert(board, :horizontal)
    Enum.each(horizontal_board, fn(col) ->
      render_column(col)
    end)
    IO.puts ""
  end

  def render_column(col) do
    row_string = Enum.reduce(col, "", fn(entry, acc) ->
      symbol = convert_colour_to_symbol(entry)
      acc <> "[#{symbol}] "
    end)
    IO.puts row_string
  end

  def convert_colour_to_symbol(colour) do
    case colour do
      :red -> "R"
      :yellow -> "Y"
      :empty -> "o"
    end
  end
end

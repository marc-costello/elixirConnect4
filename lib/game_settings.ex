defmodule GameSettings do

  @columns 7
  @rows 6

  def no_columns, do: @columns
  def no_rows, do: @rows

  def max_column_index, do: no_columns - 1
  def max_row_index, do: no_rows - 1

end

defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    IntcodeMachine.new(input).([])
    |> Enum.chunk_every(3)
    |> Enum.reduce(%{}, &update_grid(&2, &1))
    |> Map.values()
    |> Enum.count(&match?(:block, &1))
  end

  def update_grid(grid, [x, y, tile_id]) do
    put_in(grid[{x, y}], interpret(tile_id))
  end

  def interpret(0), do: :empty
  def interpret(1), do: :wall
  def interpret(2), do: :block
  def interpret(3), do: :horizontal_paddle
  def interpret(4), do: :ball
end

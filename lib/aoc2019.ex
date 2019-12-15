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

  def arcade_cabinet(input) do
    machine =
      input
      |> IntcodeMachine.parse()
      |> IntcodeMachine.run()

    machine
    |> get_updates()
    |> Enum.reduce(
      %{grid: %{}, score: 0, machine: machine, ball: nil, horizontal_paddle: nil},
      fn [x, y, tile_id], cabinet ->
        update_cabinet(cabinet, {x, y}, tile_id)
      end
    )
  end

  def get_updates(machine) do
    machine
    |> Map.get(:outputs)
    |> Enum.chunk_every(3)
  end

  def to_s(cabinet) do
    grid =
      cabinet.grid
      |> Map.merge(%{cabinet.ball => :ball, cabinet.horizontal_paddle => :horizontal_paddle})

    {min_x, max_x} = grid |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = grid |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()

    grid_s =
      for y <- min_y..max_y do
        for x <- min_x..max_x do
          case grid[{x, y}] do
            :ball -> "o"
            :horizontal_paddle -> "-"
            :empty -> " "
            :wall -> "X"
            :block -> "#"
          end
        end
        |> Enum.join()
      end
      |> Enum.join("\n")

    "#{cabinet.score}\n#{grid_s}"
  end

  def update_cabinet(cabinet, {-1, 0}, score) do
    put_in(cabinet.score, score)
  end

  def update_cabinet(cabinet, position, 3) do
    put_in(cabinet.horizontal_paddle, position)
  end

  def update_cabinet(cabinet, position, 4) do
    put_in(cabinet.ball, position)
  end

  def update_cabinet(cabinet, position, tile_id) do
    put_in(cabinet.grid[position], interpret(tile_id))
  end

  def update_cabinet(cabinet, [x, y, tile_id]) do
    update_in(cabinet.grid, &update_grid(&1, [x, y, tile_id]))
  end

  def update_grid(grid, [x, y, 4]) do
    put_in(grid[{x, y}], interpret(4))
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

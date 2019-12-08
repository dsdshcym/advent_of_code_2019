defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def part_1(input) do
    map = parse(input)

    map
    |> Map.keys()
    |> Enum.map(&total_orbits(map, &1))
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, map ->
      [object, direct_orbit] = String.split(line, ")")

      Map.update(map, object, [direct_orbit], fn direct_orbits ->
        [direct_orbit | direct_orbits]
      end)
    end)
  end

  def total_orbits(map, object) do
    map
    |> Map.get(object, [])
    |> Enum.map(&(total_orbits(map, &1) + 1))
    |> Enum.sum()
  end
end

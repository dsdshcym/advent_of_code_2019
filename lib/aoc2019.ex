defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def part_1(input) do
    map = parse(input)

    map
    |> Map.keys()
    |> Enum.map(&ancestors(map, &1))
    |> Enum.map(&Enum.count(&1))
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, map ->
      [orbited, orbiting] = String.split(line, ")")
      Map.put_new(map, orbiting, orbited)
    end)
  end

  def ancestors(_map, "COM") do
    []
  end

  def ancestors(map, object) do
    ancestor = ancestor(map, object)
    [ancestor | ancestors(map, ancestor)]
  end

  defp ancestor(map, object) do
    {:ok, ancestor} = Map.fetch(map, object)
    ancestor
  end
end

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

  def part_2(input) do
    map = parse(input)

    minimum_orbit_transfer(map, "YOU", "SAN")
  end

  def minimum_orbit_transfer(map, o1, o2) do
    chain1 = [o1 | ancestors(map, o1)]
    chain2 = [o2 | ancestors(map, o2)]

    # lca: Lowest Common Ancestor
    lca = first_intersection(chain1, chain2)

    Enum.find_index(chain1, &match?(^lca, &1)) + Enum.find_index(chain2, &match?(^lca, &1)) -
      2
  end

  def first_intersection([_ | rest_chain1] = chain1, chain2) when length(chain1) > length(chain2),
    do: first_intersection(rest_chain1, chain2)

  def first_intersection(chain1, [_ | rest_chain2] = chain2) when length(chain1) < length(chain2),
    do: first_intersection(chain1, rest_chain2)

  def first_intersection([intersection | _], [intersection | _]), do: intersection

  def first_intersection([_ | rest_chain1], [_ | rest_chain2]),
    do: first_intersection(rest_chain1, rest_chain2)
end

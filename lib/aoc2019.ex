defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    asteroids = parse(input)

    asteroids
    |> Enum.map(&detectable_count(&1, List.delete(asteroids, &1)))
    |> Enum.max()
  end

  defp parse(input) do
    input
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {cell, _x} ->
        cell == "#"
      end)
      |> Enum.map(fn {_, x} -> {x, y} end)
    end)
  end

  defp detectable_count(asteroid, others) do
    Enum.count(others, &detectable?(asteroid, &1, List.delete(others, &1)))
  end

  defp detectable?(from, to, others) do
    !anything_in_between(from, to, others)
  end

  defp anything_in_between(from, to, others) do
    Enum.any?(others, &in_between(from, &1, to))
  end

  defp in_between(p1, p2, p3) do
    same_line?(p1, p2, p3) && between?(p1, p2, p3)
  end

  defp same_line?({x1, y1}, {x2, y2}, {x3, y3}) do
    (y2 - y1) * (x3 - x2) == (y3 - y2) * (x2 - x1)
  end

  defp between?({x1, y1}, {x2, y2}, {x3, y3}) do
    Enum.member?(x1..x3, x2) && Enum.member?(y1..y3, y2)
  end
end

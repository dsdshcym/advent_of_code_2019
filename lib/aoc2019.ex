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

  def p2(input, vaporized_index \\ 200) do
    asteroids = parse(input)

    center = Enum.max_by(asteroids, &detectable_count(&1, List.delete(asteroids, &1)))

    {x, y} =
      asteroids
      |> List.delete(center)
      |> vaporize_queue(center)
      |> Enum.at(vaporized_index - 1)

    x * 100 + y
  end

  defp vaporize_queue([], _center), do: []

  defp vaporize_queue(others, center) do
    {detectables, undetectables} =
      Enum.split_with(others, &detectable?(center, &1, List.delete(others, &1)))

    sort_clockwise_around(detectables, center) ++ vaporize_queue(undetectables, center)
  end

  defp sort_clockwise_around(asteroids, {xc, yc}) do
    {right, left} =
      Enum.split_with(asteroids, fn
        {^xc, yo} -> yo < yc
        {xo, _yo} -> xo > xc
      end)

    Enum.sort_by(right, & &1, fn {x1, y1}, {x2, y2} ->
      (xc - x1) * (yc - y2) > (xc - x2) * (yc - y1)
    end) ++
      Enum.sort_by(left, & &1, fn {x1, y1}, {x2, y2} ->
        (xc - x1) * (yc - y2) > (xc - x2) * (yc - y1)
      end)
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

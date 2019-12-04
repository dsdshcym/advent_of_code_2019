defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def part_1(input) do
    [wire_1, wire_2] =
      input
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> Enum.map(&to_wire/1)

    intersection(wire_1, wire_2)
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  def part_2(input) do
    [wire_1, wire_2] =
      input
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> Enum.map(&to_wire/1)

    intersection(wire_1, wire_2)
    |> Enum.map(&(signal_delay(wire_1, &1) + signal_delay(wire_2, &1)))
    |> Enum.min()
  end

  def parse(line) do
    line
    |> String.split(",")
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(<<direction::binary-size(1), step::binary>>) do
    {parse_direction(direction), String.to_integer(step)}
  end

  defp parse_direction("R"), do: :right
  defp parse_direction("L"), do: :left
  defp parse_direction("U"), do: :up
  defp parse_direction("D"), do: :down

  def to_wire(instructions) do
    to_wire({0, 0}, instructions, [])
  end

  defp to_wire(_point, [], wire), do: wire

  defp to_wire(point, [instruction | rest], wire) do
    {next_point, line} = to_line(point, instruction)

    to_wire(next_point, rest, wire ++ line)
  end

  defp to_line(point, {direction, step}) do
    line =
      point
      |> Stream.iterate(&move(&1, direction))
      |> Stream.drop(1)
      |> Enum.take(step)

    {List.last(line), line}
  end

  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :up), do: {x, y + 1}
  defp move({x, y}, :down), do: {x, y - 1}

  defp intersection(wire_1, wire_2) do
    MapSet.intersection(MapSet.new(wire_1), MapSet.new(wire_2))
  end

  defp manhattan_distance(point), do: manhattan_distance(point, {0, 0})

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def signal_delay(wire, point) do
    Enum.find_index(wire, &(&1 == point)) + 1
  end
end

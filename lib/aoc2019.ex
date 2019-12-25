defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    input
    |> parse(SimpleWorld)
    |> stream(SimpleWorld)
    |> find_repeated()
    |> biodiversity_rating()
  end

  def parse(input, module), do: module.parse(input)

  def stream(world, module) do
    Stream.iterate(world, &module.step/1)
  end

  def find_repeated(stream) do
    Enum.reduce_while(stream, MapSet.new(), fn ele, visited ->
      if MapSet.member?(visited, ele) do
        {:halt, ele}
      else
        {:cont, MapSet.put(visited, ele)}
      end
    end)
  end

  def biodiversity_rating(world) do
    for {{x, y}, status} <- world, status == :bugs do
      :math.pow(2, y * 5 + x)
    end
    |> Enum.sum()
  end
end

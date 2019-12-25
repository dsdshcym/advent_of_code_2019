defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    input
    |> parse()
    |> stream()
    |> find_repeated()
    |> biodiversity_rating()
  end

  def parse(input), do: do_parse(input, {0, 0}, %{})

  defp do_parse([], _pos, world),
    do: world

  defp do_parse([?\n | rest], {_x, y}, world),
    do: do_parse(rest, {0, y + 1}, world)

  defp do_parse([char | rest], {x, y}, world),
    do: do_parse(rest, {x + 1, y}, Map.put(world, {x, y}, interpret(char)))

  defp interpret(?.), do: :empty
  defp interpret(?#), do: :bugs

  def stream(world) do
    Stream.iterate(world, &step/1)
  end

  def step(world) do
    world
    |> Enum.map(fn
      {pos, :bugs} ->
        next_status = if adjacent_bugs(world, pos) == 1, do: :bugs, else: :empty
        {pos, next_status}

      {pos, :empty} ->
        next_status = if adjacent_bugs(world, pos) in [1, 2], do: :bugs, else: :empty
        {pos, next_status}
    end)
    |> Enum.into(%{})
  end

  def adjacent_bugs(world, pos) do
    pos
    |> adjacents()
    |> Enum.map(&Map.fetch(world, &1))
    |> Enum.count(&match?({:ok, :bugs}, &1))
  end

  def adjacents({x, y}) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y}
    ]
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

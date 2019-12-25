defmodule SimpleWorld do
  def parse(input), do: do_parse(input, {0, 0}, %{})

  defp do_parse([], _pos, world),
    do: world

  defp do_parse([?\n | rest], {_x, y}, world),
    do: do_parse(rest, {0, y + 1}, world)

  defp do_parse([char | rest], {x, y}, world),
    do: do_parse(rest, {x + 1, y}, Map.put(world, {x, y}, interpret(char)))

  defp interpret(?.), do: :empty
  defp interpret(?#), do: :bugs

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
end

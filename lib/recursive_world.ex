defmodule RecursiveWorld do
  def parse(input) do
    level_0 = parse_grid(input)

    %{0 => level_0}
  end

  defp empty_grid do
    parse_grid('''
    .....
    .....
    .....
    .....
    .....
    ''')
  end

  def parse_grid(input) do
    SimpleWorld.parse(input)
    |> Map.delete({2, 2})
  end

  def step(world) do
    {min_level, max_level} = world |> Map.keys() |> Enum.min_max()

    for level <- (min_level - 1)..(max_level + 1),
        into: %{},
        do: step_level(world, level)
  end

  def step_level(world, level) do
    new_grid =
      world
      |> get_grid(level)
      |> Enum.map(fn
        {pos, :bugs} ->
          next_status = if adjacent_bugs(world, level, pos) == 1, do: :bugs, else: :empty
          {pos, next_status}

        {pos, :empty} ->
          next_status = if adjacent_bugs(world, level, pos) in [1, 2], do: :bugs, else: :empty
          {pos, next_status}
      end)
      |> Enum.into(%{})

    {level, new_grid}
  end

  defp adjacent_bugs(world, level, pos) do
    {pos, level}
    |> adjacents()
    |> Enum.map(&fetch!(world, &1))
    |> Enum.count(&match?(:bugs, &1))
  end

  @doc """
       |     |         |     |
    1  |  2  |    3    |  4  |  5
       |     |         |     |
  -----+-----+---------+-----+-----
       |     |         |     |
    6  |  7  |    8    |  9  |  10
       |     |         |     |
  -----+-----+---------+-----+-----
       |     |A|B|C|D|E|     |
       |     |-+-+-+-+-|     |
       |     |F|G|H|I|J|     |
       |     |-+-+-+-+-|     |
   11  | 12  |K|L|?|N|O|  14 |  15
       |     |-+-+-+-+-|     |
       |     |P|Q|R|S|T|     |
       |     |-+-+-+-+-|     |
       |     |U|V|W|X|Y|     |
  -----+-----+---------+-----+-----
       |     |         |     |
   16  | 17  |    18   |  19 |  20
       |     |         |     |
  -----+-----+---------+-----+-----
       |     |         |     |
   21  | 22  |    23   |  24 |  25
       |     |         |     |
  """
  def adjacents({pos, level}) do
    [:left, :right, :up, :down]
    |> Enum.flat_map(&adjacents_at({pos, level}, &1))
  end

  def adjacents_at({{0, _y}, level}, :left), do: [{{1, 2}, level - 1}]
  def adjacents_at({{3, 2}, level}, :left), do: for(y <- 0..4, do: {{4, y}, level + 1})
  def adjacents_at({{x, y}, level}, :left), do: [{{x - 1, y}, level}]

  def adjacents_at({{4, _y}, level}, :right), do: [{{3, 2}, level - 1}]
  def adjacents_at({{1, 2}, level}, :right), do: for(y <- 0..4, do: {{0, y}, level + 1})
  def adjacents_at({{x, y}, level}, :right), do: [{{x + 1, y}, level}]

  def adjacents_at({{_x, 0}, level}, :up), do: [{{2, 1}, level - 1}]
  def adjacents_at({{2, 3}, level}, :up), do: for(x <- 0..4, do: {{x, 4}, level + 1})
  def adjacents_at({{x, y}, level}, :up), do: [{{x, y - 1}, level}]

  def adjacents_at({{_x, 4}, level}, :down), do: [{{2, 3}, level - 1}]
  def adjacents_at({{2, 1}, level}, :down), do: for(x <- 0..4, do: {{x, 0}, level + 1})
  def adjacents_at({{x, y}, level}, :down), do: [{{x, y + 1}, level}]

  def fetch!(world, {pos, level}) do
    world
    |> get_grid(level)
    |> Map.fetch!(pos)
  end

  def get_grid(world, level) do
    Map.get(world, level, empty_grid())
  end
end

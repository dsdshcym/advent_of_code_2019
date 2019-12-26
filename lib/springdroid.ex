defmodule Springdroid do
  @jump_to_d '''
  OR A J
  AND B J
  AND C J
  NOT J J
  AND D J
  WALK
  '''

  @look_ahead_jump '''
  OR A J
  AND B J
  AND C J
  NOT J J
  OR I T
  OR F T
  AND E T
  OR H T
  AND T J
  AND D J
  RUN
  '''

  def p1(input) do
    m = IntcodeMachine.parse(input)
    m = IntcodeMachine.run(%{m | inputs: @jump_to_d})

    {_prompts, [hull_damage]} = Enum.split(m.outputs, -1)

    hull_damage
  end

  @doc """
    (!A + !B + !C)(E(I + F) + H)D
  """
  def p2(input) do
    m = IntcodeMachine.parse(input)
    m = IntcodeMachine.run(%{m | inputs: @look_ahead_jump})

    {_prompts, [hull_damage]} = Enum.split(m.outputs, -1)

    hull_damage
  end

  @doc """
  ABCDEFGHI
  ...#...#.
  ...#...##
  ...#..##.
  ...#..###
  ...#.#.#.
  ...#.#.##
  ...#.###.
  ...#.####
  ...##...#
  ...##..#.
  ...##..##
  ...##.#.#
  ...##.##.
  ...##.###
  ...###...
  ...###..#
  ...###.#.
  ...###.##
  ...####..
  ...####.#
  ...#####.
  ...######
  ..##...#.
  ..##...##
  ..##..##.
  ..##..###
  ..##.#.#.
  ..##.#.##
  ..##.###.
  ..##.####
  ..###...#
  ..###..#.
  ..###..##
  ..###.#.#
  ..###.##.
  ..###.###
  ..####...
  ..####..#
  ..####.#.
  ..####.##
  ..#####..
  ..#####.#
  ..######.
  ..#######
  .#.#...#.
  .#.#...##
  .#.#..##.
  .#.#..###
  .#.#.#.#.
  .#.#.#.##
  .#.#.###.
  .#.#.####
  .#.##...#
  .#.##..#.
  .#.##..##
  .#.##.#.#
  .#.##.##.
  .#.##.###
  .#.###...
  .#.###..#
  .#.###.#.
  .#.###.##
  .#.####..
  .#.####.#
  .#.#####.
  .#.######
  .###...#.
  .###...##
  .###..##.
  .###..###
  .###.#.#.
  .###.#.##
  .###.###.
  .###.####
  .####...#
  .####..#.
  .####..##
  .####.#.#
  .####.##.
  .####.###
  .#####...
  .#####..#
  .#####.#.
  .#####.##
  .######..
  .######.#
  .#######.
  .########
  #..#...#.
  #..#...##
  #..#..##.
  #..#..###
  #..#.#.#.
  #..#.#.##
  #..#.###.
  #..#.####
  #..##..#.
  #..##.##.
  #.##...#.
  #.##...##
  #.##..##.
  #.##..###
  #.##.#.#.
  #.##.#.##
  #.##.###.
  #.##.####
  #.###..#.
  #.###.##.
  ##.#...#.
  ##.#...##
  ##.#..##.
  ##.#..###
  ##.##..#.
  ##.##.##.
  """
  def walk_or_jump?([?. | _]), do: {:error, :fall}
  def walk_or_jump?([]), do: {:ok, :walk}

  def walk_or_jump?(road) do
    with {:ok, _} <- walk_or_jump?(Enum.drop(road, 1)) do
      {:ok, :walk}
    else
      {:error, _} ->
        with {:ok, _} <- walk_or_jump?(Enum.drop(road, 4)) do
          {:ok, :jump}
        else
          {:error, _} ->
            {:error, :impossible}
        end
    end
  end
end

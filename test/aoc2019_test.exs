defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input '''
  ##.#.
  .#.##
  .#...
  #..#.
  .##..\
  '''

  describe "p1/1" do
    test "example" do
      assert AoC2019.p1('''
             ....#
             #..#.
             #..##
             ..#..
             #....\
             ''') == 2_129_920
    end

    test "test input" do
      assert AoC2019.p1(@input) == 17_321_586
    end
  end

  describe "step/1" do
    test "example" do
      assert AoC2019.step(
               build('''
               ....#
               #..#.
               #..##
               ..#..
               #....\
               ''')
             ) ==
               build('''
               #..#.
               ####.
               ###.#
               ##.##
               .##..
               ''')
    end
  end

  defp build(input), do: AoC2019.parse(input)
end

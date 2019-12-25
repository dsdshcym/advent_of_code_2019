defmodule SimpleWorldTest do
  use ExUnit.Case, async: true

  describe "step/1" do
    test "example" do
      assert SimpleWorld.step(
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

  defp build(input), do: SimpleWorld.parse(input)
end

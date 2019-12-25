defmodule RecursiveWorldTest do
  use ExUnit.Case, async: true

  describe "step/1" do
    test "example" do
      world =
        build('''
        ....#
        #..#.
        #..##
        ..#..
        #....
        ''')

      new_world =
        world
        |> Stream.iterate(&RecursiveWorld.step/1)
        |> Enum.at(10)

      assert new_world[-5] ==
               build('''
               ..#..
               .#.#.
               ....#
               .#.#.
               ..#..
               ''')[0]

      assert new_world[5] ==
               build('''
               ####.
               #..#.
               #..#.
               ####.
               .....
               ''')[0]
    end
  end

  defp build(input), do: RecursiveWorld.parse(input)
end

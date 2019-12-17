defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  describe "to_menu/1" do
    test "example" do
      input = "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

      assert AoC2019.to_menu(input) == %{
               {"FUEL", 1} => [{"A", 7}, {"E", 1}],
               {"E", 1} => [{"A", 7}, {"D", 1}],
               {"D", 1} => [{"A", 7}, {"C", 1}],
               {"C", 1} => [{"A", 7}, {"B", 1}],
               {"B", 1} => [{"ORE", 1}],
               {"A", 10} => [{"ORE", 10}]
             }
    end
  end
end

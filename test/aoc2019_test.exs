defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input File.read!(Path.join(__DIR__, "day_8_input.txt")) |> String.trim_trailing()

  describe "p1/1" do
    test "example" do
      assert AoC2019.p1("121456789012", 3, 2) == 2
      assert AoC2019.p1("021456782212", 3, 2) == 3
    end

    test "test input" do
      assert AoC2019.p1(@input, 25, 6) == 2032
    end
  end
end

defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  describe "valid_password?/1" do
    test "It is a six-digit number" do
      assert AoC2019.valid_password?(123_356) == true
      assert AoC2019.valid_password?(123_35) == false
      assert AoC2019.valid_password?(1_233_567) == false
    end

    test "Two adjacent digits are the same (like 22 in 122345)" do
      assert AoC2019.valid_password?(123_367) == true
      assert AoC2019.valid_password?(234_567) == false
    end

    test "Going from left to right, the digits never decrease" do
      assert AoC2019.valid_password?(134_489) == true
      assert AoC2019.valid_password?(871_345) == false
    end

    test "the two adjacent matching digits are not part of a larger group of matching digits." do
      assert AoC2019.valid_password?(112_233) == true
      assert AoC2019.valid_password?(123_444) == false

      "111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22)."
    end
  end
end

input = 134_564..585_159

input
|> Enum.count(&AoC2019.valid_password?/1)
|> IO.inspect(label: "Part 2")

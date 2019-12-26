defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input """
  deal with increment 2
  cut 3310
  deal with increment 13
  cut -9214
  deal with increment 14
  deal into new stack
  deal with increment 26
  deal into new stack
  deal with increment 62
  cut -1574
  deal with increment 74
  cut -7102
  deal with increment 41
  cut 7618
  deal with increment 70
  cut 7943
  deal into new stack
  deal with increment 52
  cut -3134
  deal with increment 21
  deal into new stack
  deal with increment 20
  deal into new stack
  deal with increment 61
  cut -2810
  deal with increment 60
  cut 3355
  deal with increment 13
  cut 3562
  deal with increment 55
  cut 2600
  deal with increment 47
  deal into new stack
  cut -7010
  deal with increment 34
  cut 1726
  deal with increment 61
  cut 2805
  deal with increment 39
  cut 1907
  deal into new stack
  cut 3915
  deal with increment 14
  cut -6590
  deal into new stack
  deal with increment 73
  deal into new stack
  deal with increment 31
  cut 1000
  deal with increment 3
  cut 8355
  deal with increment 2
  cut -5283
  deal with increment 50
  cut -7150
  deal with increment 71
  cut 6728
  deal with increment 58
  cut -814
  deal with increment 14
  cut -8392
  deal with increment 71
  cut 7674
  deal with increment 46
  deal into new stack
  deal with increment 55
  cut 7026
  deal with increment 17
  cut 1178
  deal with increment 10
  cut -8205
  deal with increment 27
  cut -55
  deal with increment 44
  cut -2392
  deal into new stack
  cut 7385
  deal with increment 36
  cut -399
  deal with increment 74
  cut 6895
  deal with increment 20
  cut 4346
  deal with increment 15
  cut -4088
  deal with increment 3
  cut 1229
  deal with increment 59
  cut 4708
  deal with increment 62
  cut 2426
  deal with increment 30
  cut 7642
  deal with increment 73
  cut 9049
  deal into new stack
  cut -3866
  deal with increment 68
  deal into new stack
  cut 1407
  """

  describe "deal_into_new_stack" do
    test "reverses the deck" do
      assert AoC2019.deal_into_new_stack([1, 2, 3]) == [3, 2, 1]
    end
  end

  describe "cut/2" do
    test "puts the several cards from the top to the bottom, retaining their order" do
      assert AoC2019.cut([1, 2, 3, 4, 5], 4) == [5, 1, 2, 3, 4]
      assert AoC2019.cut([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 3) == [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
    end

    test "accepts negative number" do
      assert AoC2019.cut([1, 2, 3, 4, 5], -2) == [4, 5, 1, 2, 3]
      assert AoC2019.cut([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], -4) == [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]
    end
  end

  describe "deal_with_increment/2" do
    test "puts card at every N step in order" do
      assert AoC2019.deal_with_increment([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 3) ==
               [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]
    end
  end

  describe "part 1" do
    test "examples" do
      deck10 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

      input = """
      deal with increment 7
      deal into new stack
      deal into new stack
      """

      assert AoC2019.p1(input, deck10) == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]

      input = """
      cut 6
      deal with increment 7
      deal into new stack
      """

      assert AoC2019.p1(input, deck10) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]

      input = """
      deal with increment 7
      deal with increment 9
      cut -2
      """

      assert AoC2019.p1(input, deck10) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]

      input = """
      deal into new stack
      cut -2
      deal with increment 7
      cut 8
      cut -4
      deal with increment 7
      cut 3
      deal with increment 9
      deal with increment 3
      cut -1
      """

      assert AoC2019.p1(input, deck10) == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
    end

    test "test input" do
      assert @input
             |> AoC2019.p1(Enum.to_list(0..10006))
             |> Enum.find_index(&Kernel.==(&1, 2019)) == 1498
    end
  end
end

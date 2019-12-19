defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  alias AoC2019.Moon

  @input """
  <x=-8, y=-18, z=6>
  <x=-11, y=-14, z=4>
  <x=8, y=-3, z=-10>
  <x=-2, y=-16, z=1>
  """

  test "p1/2" do
    e1 = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    assert AoC2019.p1(e1, 10) == 179

    e2 = """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """

    assert AoC2019.p1(e2, 100) == 1940

    assert AoC2019.p1(@input, 1000) == 9743
  end

  describe "parse/1" do
    test "example" do
      assert AoC2019.parse("""
             <x=-1, y=0, z=2>
             <x=2, y=-10, z=-7>
             <x=4, y=-8, z=8>
             <x=3, y=5, z=-1>
             """) == [
               Moon.new({-1, 0, 2}),
               Moon.new({2, -10, -7}),
               Moon.new({4, -8, 8}),
               Moon.new({3, 5, -1})
             ]
    end
  end

  test "p2/1" do
    assert AoC2019.p2("""
           <x=-1, y=0, z=2>
           <x=2, y=-10, z=-7>
           <x=4, y=-8, z=8>
           <x=3, y=5, z=-1>
           """) == 2772

    assert AoC2019.p2("""
           <x=-8, y=-10, z=0>
           <x=5, y=5, z=10>
           <x=2, y=-7, z=3>
           <x=9, y=-8, z=-3>
           """) ==
             4_686_774_924

    assert AoC2019.p2(@input) == 288_684_633_706_728
  end

  describe "run/2" do
    test "returns moons when step = 0" do
      assert AoC2019.run([1, 2, 3, 4], 0) == [1, 2, 3, 4]
    end

    test "applies gravity and velocity to moons" do
      assert AoC2019.run(
               [
                 Moon.new({-1, 0, 2}),
                 Moon.new({2, -10, -7}),
                 Moon.new({4, -8, 8}),
                 Moon.new({3, 5, -1})
               ],
               2
             ) == [
               Moon.new({5, -3, -1}, {3, -2, -2}),
               Moon.new({1, -2, 2}, {-2, 5, 6}),
               Moon.new({1, -4, -1}, {0, 3, -6}),
               Moon.new({1, -4, 2}, {-1, -6, 2})
             ]
    end
  end
end

defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input """
  #.....#...#.........###.#........#..
  ....#......###..#.#.###....#......##
  ......#..###.......#.#.#.#..#.......
  ......#......#.#....#.##....##.#.#.#
  ...###.#.#.......#..#...............
  ....##...#..#....##....#...#.#......
  ..##...#.###.....##....#.#..##.##...
  ..##....#.#......#.#...#.#...#.#....
  .#.##..##......##..#...#.....##...##
  .......##.....#.....##..#..#..#.....
  ..#..#...#......#..##...#.#...#...##
  ......##.##.#.#.###....#.#..#......#
  #..#.#...#.....#...#...####.#..#...#
  ...##...##.#..#.....####.#....##....
  .#....###.#...#....#..#......#......
  .##.#.#...#....##......#.....##...##
  .....#....###...#.....#....#........
  ...#...#....##..#.#......#.#.#......
  .#..###............#.#..#...####.##.
  .#.###..#.....#......#..###....##..#
  #......#.#.#.#.#.#...#.#.#....##....
  .#.....#.....#...##.#......#.#...#..
  ...##..###.........##.........#.....
  ..#.#..#.#...#.....#.....#...###.#..
  .#..........#.......#....#..........
  ...##..#..#...#..#...#......####....
  .#..#...##.##..##..###......#.......
  .##.....#.......#..#...#..#.......#.
  #.#.#..#..##..#..............#....##
  ..#....##......##.....#...#...##....
  .##..##..#.#..#.................####
  ##.......#..#.#..##..#...#..........
  #..##...#.##.#.#.........#..#..#....
  .....#...#...#.#......#....#........
  ....#......###.#..#......##.....#..#
  #..#...##.........#.....##.....#....
  """

  describe "part 1" do
    test "examples" do
      # Best is 3,4 with 8 other asteroids detected:
      assert AoC2019.p1("""
             .#..#
             .....
             #####
             ....#
             ...##
             """) == 8

      # Best is 5,8 with 33 other asteroids detected:

      assert AoC2019.p1("""
             ......#.#.
             #..#.#....
             ..#######.
             .#.#.###..
             .#..#.....
             ..#....#.#
             #..#....#.
             .##.#..###
             ##...#..#.
             .#....####
             """) == 33

      # Best is 1,2 with 35 other asteroids detected:

      assert AoC2019.p1("""
             #.#...#.#.
             .###....#.
             .#....#...
             ##.#.#.#.#
             ....#.#.#.
             .##..###.#
             ..#...##..
             ..##....##
             ......#...
             .####.###.
             """) == 35

      # Best is 6,3 with 41 other asteroids detected:

      assert AoC2019.p1("""
             .#..#..###
             ####.###.#
             ....###.#.
             ..###.##.#
             ##.##.#.#.
             ....###..#
             ..#.#..#.#
             #..#.#.###
             .##...##.#
             .....#.#..
             """) == 41

      # Best is 11,13 with 210 other asteroids detected:

      assert AoC2019.p1("""
             .#..##.###...#######
             ##.############..##.
             .#.######.########.#
             .###.#######.####.#.
             #####.##.#.##.###.##
             ..#####..#.#########
             ####################
             #.####....###.#.#.##
             ##.#################
             #####.##.###..####..
             ..######..##.#######
             ####.##.####...##..#
             .#####..#.######.###
             ##...#.##########...
             #.##########.#######
             .####.#.###.###.#.##
             ....##.##.###..#####
             .#.#.###########.###
             #.#.#.#####.####.###
             ###.##.####.##.#..##
             """) == 210
    end

    test "test input" do
      assert AoC2019.p1(@input) == 303
    end
  end

  describe "part 2" do
    test "examples" do
      assert AoC2019.p2(
               """
               .#....#####...#..
               ##...##.#####..##
               ##...#...#.#####.
               ..#.....#...###..
               ..#.#.....#....##
               """,
               4
             ) == 1000

      assert(
        AoC2019.p2(
          """
          .#..##.###...#######
          ##.############..##.
          .#.######.########.#
          .###.#######.####.#.
          #####.##.#.##.###.##
          ..#####..#.#########
          ####################
          #.####....###.#.#.##
          ##.#################
          #####.##.###..####..
          ..######..##.#######
          ####.##.####...##..#
          .#####..#.######.###
          ##...#.##########...
          #.##########.#######
          .####.#.###.###.#.##
          ....##.##.###..#####
          .#.#.###########.###
          #.#.#.#####.####.###
          ###.##.####.##.#..##
          """,
          100
        ) == 1016
      )
    end

    test "test input" do
      assert AoC2019.p2(@input) == 408
    end
  end
end

defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input 59_740_570_066_545_297_251_154_825_435_366_340_213_217_767_560_317_431_249_230_856_126_186_684_853_914_890_740_372_813_900_333_546_650_470_120_212_696_679_073_532_070_321_905_251_098_818_938_842_748_495_771_795_700_430_939_051_767_095_353_191_994_848_143_745_556_802_800_558_539_768_000_823_464_027_739_836_197_374_419_471_170_658_410_058_272_015_907_933_865_039_230_664_448_382_679_990_256_536_462_904_281_204_159_189_130_560_932_257_840_180_904_440_715_926_277_456_416_159_792_346_144_565_015_659_158_009_309_198_333_360_851_441_615_766_440_174_908_079_262_585_930_515_201_551_023_564_548_297_813_812_053_697_661_866_316_093_326_224_437_533_276_374_827_798_775_284_521_047_531_812_721_015_476_676_752_881_281_681_617_831_848_489_744_836_944_748_112_121_951_295_833_143_568_224_473_778_646_284_752_636_203_058_705_797_036_682_752_546_769_318_376_384_677_548_240_590

  describe "part 1" do
    test "examples" do
      assert AoC2019.p1(80_871_224_585_914_546_619_083_218_645_595) == 24_176_176
      assert AoC2019.p1(19_617_804_207_202_209_144_916_044_189_917) == 73_745_418
      assert AoC2019.p1(69_317_163_492_948_606_335_995_924_319_873) == 52_432_133
    end

    test "test input" do
      assert AoC2019.p1(@input) == 50_053_207
    end
  end

  describe "phase" do
    test "example" do
      assert AoC2019.phase([1, 2, 3, 4, 5, 6, 7, 8]) == [4, 8, 2, 2, 6, 1, 5, 8]
      assert AoC2019.phase([4, 8, 2, 2, 6, 1, 5, 8]) == [3, 4, 0, 4, 0, 4, 3, 8]
      assert AoC2019.phase([3, 4, 0, 4, 0, 4, 3, 8]) == [0, 3, 4, 1, 5, 5, 1, 8]
      assert AoC2019.phase([0, 3, 4, 1, 5, 5, 1, 8]) == [0, 1, 0, 2, 9, 4, 9, 8]
    end
  end
end

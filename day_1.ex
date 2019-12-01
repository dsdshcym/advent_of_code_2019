ExUnit.start()

defmodule Rocket do
  def required_fuel(mass) do
    mass
    |> Kernel.div(3)
    |> Kernel.-(2)
    |> case do
         positive when positive > 0 -> positive
         _ -> 0
       end
  end

  def fuel_in_total(mass) do
    mass
    |> required_fuel()
    |> total()
  end

  defp total(mass) do
    case required_fuel(mass) do
      0 -> mass
      fuel -> mass + total(fuel)
    end
  end
end

defmodule RocketTest do
  use ExUnit.Case, async: true

  test "required_fuel/1" do
    assert Rocket.required_fuel(12) == 2
    assert Rocket.required_fuel(14) == 2
    assert Rocket.required_fuel(1969) == 654
    assert Rocket.required_fuel(100_756) == 33583
    assert Rocket.required_fuel(2) == 0
  end

  test "fuel_in_total/1" do
    assert Rocket.fuel_in_total(14) == 2
    assert Rocket.fuel_in_total(1969) == 966
    assert Rocket.fuel_in_total(100756) == 50346
  end
end

[
  90859,
  127_415,
  52948,
  92106,
  106_899,
  72189,
  60084,
  79642,
  138_828,
  103_609,
  149_073,
  127_749,
  86976,
  104_261,
  139_341,
  81414,
  102_622,
  131_030,
  120_878,
  96809,
  130_331,
  119_212,
  52317,
  108_990,
  136_871,
  67279,
  76541,
  113_254,
  77739,
  75027,
  53863,
  97732,
  65646,
  87851,
  63712,
  92660,
  131_821,
  127_837,
  52363,
  70349,
  66110,
  132_249,
  50319,
  125_948,
  98360,
  137_675,
  61957,
  143_540,
  137_402,
  135_774,
  51376,
  144_833,
  118_646,
  128_136,
  141_140,
  82856,
  63345,
  143_617,
  79733,
  73449,
  116_126,
  73591,
  63899,
  110_409,
  79602,
  77485,
  64050,
  131_760,
  90509,
  112_728,
  55181,
  55329,
  98597,
  126_579,
  108_227,
  80707,
  92962,
  90396,
  123_775,
  125_248,
  128_814,
  64593,
  63108,
  76486,
  107_135,
  111_064,
  142_569,
  68579,
  149_006,
  52258,
  143_477,
  131_889,
  142_506,
  146_732,
  58663,
  92013,
  62410,
  71035,
  51208,
  66372
]
|> Enum.map(&Rocket.fuel_in_total/1)
|> Enum.sum()
|> IO.inspect()

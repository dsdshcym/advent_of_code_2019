defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    input
    |> Integer.digits()
    |> Stream.iterate(&phase/1)
    |> Enum.at(100)
    |> Enum.take(8)
    |> Enum.join()
    |> String.to_integer()
  end

  def phase(digits) do
    for i <- 1..length(digits) do
      [0, 1, 0, -1]
      |> Stream.map(&List.duplicate(&1, i))
      |> Stream.concat()
      |> Stream.cycle()
      |> Stream.drop(1)
      |> Stream.zip(digits)
      |> Stream.map(fn {value, digit} -> value * digit end)
      |> Enum.sum()
      |> abs()
      |> rem(10)
    end
  end
end

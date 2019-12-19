defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    digits =
      input
      |> Integer.digits()

    phase_fn = phase_fn(length(digits))

    digits
    |> Stream.iterate(phase_fn)
    |> Enum.at(100)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  def p2(digits) do
    offset = digits |> Enum.take(7) |> Integer.undigits()

    true = offset >= div(length(digits), 2)

    digits
    |> Enum.drop(offset)
    |> Stream.iterate(&naive_phase/1)
    |> Enum.at(100)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  def naive_phase(digits) do
    List.foldr(
      digits,
      [],
      fn
        digit, [] -> [digit]
        digit, [previous | _] = rest -> [rem(previous + digit, 10) | rest]
      end
    )
  end

  def phase_fn(length) do
    patterns =
      for i <- 1..length do
        [0, 1, 0, -1]
        |> Stream.map(&List.duplicate(&1, i))
        |> Stream.concat()
        |> Stream.cycle()
        |> Stream.drop(1)
        |> Enum.take(length)
      end

    fn digits ->
      patterns
      |> Enum.map(fn pattern ->
        pattern
        |> Enum.zip(digits)
        |> Enum.map(fn {value, digit} -> value * digit end)
        |> Enum.sum()
        |> abs()
        |> rem(10)
      end)
    end
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

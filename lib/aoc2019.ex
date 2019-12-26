defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input, deck) do
    input
    |> parse
    |> Enum.reduce(deck, fn {fun, args}, deck -> apply(__MODULE__, fun, [deck | args]) end)
  end

  def p2(input) do
    length = 119_315_717_514_047
    time = 101_741_582_076_661

    function =
      input
      |> AoC2019.parse()
      |> Enum.map(fn
        {:deal_into_new_stack, []} -> AoC2019.r_deal_into_new_stack(length)
        {:cut, [count]} -> AoC2019.r_cut(length, count)
        {:deal_with_increment, [inc]} -> AoC2019.r_deal_with_increment(length, inc)
      end)
      |> Enum.reverse()
      |> compose(length)

    function
    |> apply_by_squaring(time, length)
    |> apply_function(2020, length)
  end

  def apply_by_squaring(function, time, length) do
    binary_time = time |> Integer.digits(2)
    squared_functions = function |> Stream.iterate(&compose(&1, &1, length))

    binary_time
    |> Enum.reverse()
    |> Stream.zip(squared_functions)
    |> Stream.reject(fn {digit, _function} -> digit == 0 end)
    |> Stream.map(fn {_digit, function} -> function end)
    |> compose(length)
  end

  def apply_function({a, b}, x, length), do: normalize(a * x + b, length)

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn
      "deal into new stack" -> {:deal_into_new_stack, []}
      "cut " <> count -> {:cut, [String.to_integer(count)]}
      "deal with increment " <> inc -> {:deal_with_increment, [String.to_integer(inc)]}
    end)
  end

  def deal_into_new_stack(deck), do: Enum.reverse(deck)

  def cut(deck, count) do
    {top, bottom} = Enum.split(deck, count)
    Enum.concat(bottom, top)
  end

  def deal_with_increment(deck, inc) do
    len = length(deck)

    for {card, index} <- Enum.with_index(deck),
        new_index = rem(index * inc, len) do
      {new_index, card}
    end
    |> Enum.sort()
    |> Enum.map(fn {_, card} -> card end)
  end

  def r_deal_into_new_stack(length), do: {-1, length - 1}

  def r_cut(_length, count), do: {1, count}

  def r_deal_with_increment(length, inc) do
    n =
      1
      |> Stream.iterate(&(&1 + length))
      |> Enum.find(&(rem(&1, inc) == 0))
      |> div(inc)

    {n, 0}
  end

  def compose(list, length) do
    list
    |> Enum.reduce(&compose(&1, &2, length))
  end

  def compose({ga, gb}, {fa, fb}, length) do
    {normalize(ga * fa, length), normalize(ga * fb + gb, length)}
  end

  def normalize(normalizee, normalizer), do: Integer.mod(normalizee, normalizer)
end

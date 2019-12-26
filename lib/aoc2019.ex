defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input, deck) do
    input
    |> parse
    |> Enum.reduce(deck, fn {fun, args}, deck -> apply(__MODULE__, fun, [deck | args]) end)
  end

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
end

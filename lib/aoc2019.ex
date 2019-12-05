defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def valid_password?(number) do
    digits = Integer.digits(number)

    six_digits?(digits) &&
      has_two_adjacent_same_digits?(digits) &&
      never_decrease?(digits)
  end

  defp six_digits?(digits) do
    length(digits) == 6
  end

  defp has_two_adjacent_same_digits?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a, b] -> a == b end)
  end

  defp never_decrease?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a <= b end)
  end
end

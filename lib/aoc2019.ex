defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def valid_password?(number) do
    digits = Integer.digits(number)

    six_digits?(digits) &&
      has_at_least_one_exact_two_adjacent_matching_digits?(digits) &&
      never_decrease?(digits)
  end

  defp six_digits?(digits) do
    length(digits) == 6
  end

  defp has_at_least_one_exact_two_adjacent_matching_digits?(digits) do
    digits
    |> run_length_encoding()
    |> Enum.any?(fn {_digit, matching_count} -> matching_count == 2 end)
  end

  defp run_length_encoding(digits) do
    run_length_encoding(digits, [])
  end

  defp run_length_encoding([], results), do: results

  defp run_length_encoding([digit | rest_digits], [{digit, count} | rest_results]),
    do: run_length_encoding(rest_digits, [{digit, count + 1} | rest_results])

  defp run_length_encoding([digit | rest_digits], results),
    do: run_length_encoding(rest_digits, [{digit, 1} | results])

  defp never_decrease?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a <= b end)
  end
end

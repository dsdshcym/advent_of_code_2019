defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def part_1(input) do
    amplifier = IntcodeMachine.new(input)

    for sequence <- permutation(0..4) do
      sequence
      |> Enum.reduce(0, fn phase_setting, input ->
        [output] = amplifier.([phase_setting, input])
        output
      end)
    end
    |> Enum.max()
  end

  def part_2(input) do
    {:ok, result} =
      permutation(5..9)
      |> Task.async_stream(fn sequence ->
        {:ok, simulator} = AmplifierSimulator.start_link(input, sequence)
        AmplifierSimulator.result(simulator)
      end)
      |> Enum.max_by(fn {:ok, result} -> result end)

    result
  end

  @doc """
  iex> AoC2019.permutation([])
  [[]]

  iex> AoC2019.permutation([1])
  [[1]]

  iex> AoC2019.permutation(1..3)
  [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
  """
  def permutation([]), do: [[]]

  def permutation(list) when is_list(list) do
    for h <- list,
        perm <- permutation(List.delete(list, h)) do
      [h | perm]
    end
  end

  def permutation(enum) do
    enum
    |> Enum.to_list()
    |> permutation()
  end

  def to_ele_rest([], _, results), do: results

  def to_ele_rest([head | rest], previous, results) do
    to_ele_rest(rest, [head | previous], [{head, previous ++ rest} | results])
  end
end

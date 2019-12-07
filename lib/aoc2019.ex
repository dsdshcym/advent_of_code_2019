defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def parse(input) do
    memory =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {value, address} -> {address, value} end)
      |> Map.new()

    {0, memory, [1], []}
  end

  def run(simulator) do
    case step(simulator) do
      {:ok, new_simulator} -> run(new_simulator)
      {:halt, new_simulator} -> new_simulator
    end
  end

  def step({ip, memory, inputs, outputs}) do
    case to_operation(memory[ip]) do
      {:plus, parameter_mode_1, parameter_mode_2} ->
        a = get(memory, ip + 1, parameter_mode_1)
        b = get(memory, ip + 2, parameter_mode_2)

        {:ok, {ip + 4, Map.put(memory, memory[ip + 3], a + b), inputs, outputs}}

      {:multiply, parameter_mode_1, parameter_mode_2} ->
        a = get(memory, ip + 1, parameter_mode_1)
        b = get(memory, ip + 2, parameter_mode_2)

        {:ok, {ip + 4, Map.put(memory, memory[ip + 3], a * b), inputs, outputs}}

      :input ->
        cp = memory[ip + 1]
        [i | rest_inputs] = inputs
        {:ok, {ip + 2, Map.put(memory, cp, i), rest_inputs, outputs}}

      {:output, parameter_mode} ->
        output = get(memory, ip + 1, parameter_mode)

        {:ok, {ip + 2, memory, inputs, outputs ++ [output]}}

      :halt ->
        {:halt, {ip + 1, memory, inputs, outputs}}
    end
  end

  def to_operation(opcode) do
    case opcode |> Integer.digits() |> pad_leading(5, 0) do
      [0, parameter_mode_2, parameter_mode_1, 0, 1] ->
        {:plus, parameter_mode_1, parameter_mode_2}

      [0, parameter_mode_2, parameter_mode_1, 0, 2] ->
        {:multiply, parameter_mode_1, parameter_mode_2}

      [_, _, _, 0, 3] ->
        :input

      [_, _, parameter_mode, 0, 4] ->
        {:output, parameter_mode}

      [_, _, _, 9, 9] ->
        :halt
    end
  end

  defp pad_leading(list, count, padding) when length(list) < count do
    List.duplicate(padding, count - length(list)) ++ list
  end

  defp pad_leading(list, _, _), do: list

  def get(memory, address, 0) do
    memory[memory[address]]
  end

  def get(memory, address, 1) do
    memory[address]
  end
end

defmodule IntcodeMachine do
  defstruct ip: 0, memory: %{}, inputs: [], outputs: []

  def new(input) do
    machine = parse(input)

    fn inputs ->
      %{outputs: outputs} = run(%{machine | inputs: inputs})

      outputs
    end
  end

  def parse(input, inputs \\ [1])

  def parse(input, inputs) do
    memory =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {value, address} -> {address, value} end)
      |> Map.new()

    %__MODULE__{memory: memory, inputs: inputs}
  end

  def run(machine) do
    case step(machine) do
      {:halt, new_machine} -> new_machine
      {_operation, new_machine} -> run(new_machine)
    end
  end

  def step(m) do
    case to_operation(m.memory[m.ip]) do
      {:plus, parameter_mode_1, parameter_mode_2} ->
        a = get(m.memory, m.ip + 1, parameter_mode_1)
        b = get(m.memory, m.ip + 2, parameter_mode_2)

        {:ok,
         %{
           m
           | ip: m.ip + 4,
             memory: Map.put(m.memory, m.memory[m.ip + 3], a + b)
         }}

      {:multiply, parameter_mode_1, parameter_mode_2} ->
        a = get(m.memory, m.ip + 1, parameter_mode_1)
        b = get(m.memory, m.ip + 2, parameter_mode_2)

        {:ok, %{m | ip: m.ip + 4, memory: Map.put(m.memory, m.memory[m.ip + 3], a * b)}}

      :input ->
        cp = m.memory[m.ip + 1]

        case m.inputs do
          [i | rest_inputs] ->
            {:ok, %{m | ip: m.ip + 2, memory: Map.put(m.memory, cp, i), inputs: rest_inputs}}

          [] ->
            input_callback = fn i -> {m.ip + 2, Map.put(m.memory, cp, i)} end

            {:await_on_input, input_callback}
        end

      {:output, parameter_mode} ->
        output = get(m.memory, m.ip + 1, parameter_mode)

        {:output, %{m | ip: m.ip + 2, memory: m.memory, outputs: m.outputs ++ [output]}}

      {:"jump-if-true", parameter_mode_1, parameter_mode_2} ->
        condition = get(m.memory, m.ip + 1, parameter_mode_1)

        new_ip =
          if condition != 0,
            do: get(m.memory, m.ip + 2, parameter_mode_2),
            else: m.ip + 3

        {:ok, %{m | ip: new_ip}}

      {:"jump-if-false", parameter_mode_1, parameter_mode_2} ->
        condition = get(m.memory, m.ip + 1, parameter_mode_1)

        new_ip =
          if condition == 0,
            do: get(m.memory, m.ip + 2, parameter_mode_2),
            else: m.ip + 3

        {:ok, %{m | ip: new_ip}}

      {:"less than", parameter_mode_1, parameter_mode_2} ->
        a = get(m.memory, m.ip + 1, parameter_mode_1)
        b = get(m.memory, m.ip + 2, parameter_mode_2)

        result = if a < b, do: 1, else: 0

        {:ok, %{m | ip: m.ip + 4, memory: Map.put(m.memory, m.memory[m.ip + 3], result)}}

      {:equals, parameter_mode_1, parameter_mode_2} ->
        a = get(m.memory, m.ip + 1, parameter_mode_1)
        b = get(m.memory, m.ip + 2, parameter_mode_2)

        result = if a == b, do: 1, else: 0

        {:ok, %{m | ip: m.ip + 4, memory: Map.put(m.memory, m.memory[m.ip + 3], result)}}

      :halt ->
        {:halt, %{m | ip: m.ip + 1}}
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

      [_, parameter_mode_2, parameter_mode_1, 0, 5] ->
        {:"jump-if-true", parameter_mode_1, parameter_mode_2}

      [_, parameter_mode_2, parameter_mode_1, 0, 6] ->
        {:"jump-if-false", parameter_mode_1, parameter_mode_2}

      [_, parameter_mode_2, parameter_mode_1, 0, 7] ->
        {:"less than", parameter_mode_1, parameter_mode_2}

      [_, parameter_mode_2, parameter_mode_1, 0, 8] ->
        {:equals, parameter_mode_1, parameter_mode_2}

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

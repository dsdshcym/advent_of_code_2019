defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def output(memory) do
    List.first(memory)
  end

  def run(stack, noun, verb) do
    stack
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> run()
  end

  def run(stack) do
    run(stack, 0)
  end

  defp run(stack, pointer) do
    op = Enum.at(stack, pointer)
    pos_1 = Enum.at(stack, pointer + 1)
    pos_2 = Enum.at(stack, pointer + 2)
    target = Enum.at(stack, pointer + 3)

    case op do
      99 ->
        stack

      1 ->
        stack
        |> List.replace_at(target, Enum.at(stack, pos_1) + Enum.at(stack, pos_2))
        |> run(pointer + 4)

      2 ->
        stack
        |> List.replace_at(target, Enum.at(stack, pos_1) * Enum.at(stack, pos_2))
        |> run(pointer + 4)
    end
  end
end

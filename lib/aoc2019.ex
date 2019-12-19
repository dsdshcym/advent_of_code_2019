defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    drone = IntcodeMachine.parse(input)

    for x <- 0..49, y <- 0..49 do
      %{outputs: [output]} = IntcodeMachine.run(%{drone | inputs: [x, y]})
      output
    end
    |> Enum.sum()
  end
end

defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input, width, height) do
    layer =
      input
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(width * height)
      |> Enum.min_by(&Enum.count(&1, fn pixel -> pixel == 0 end))

    Enum.count(layer, &Kernel.==(1, &1)) * Enum.count(layer, &Kernel.==(2, &1))
  end
end

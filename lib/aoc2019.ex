defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    input
    |> IntcodeMachine.parse()
    |> beam()
    |> Stream.take_while(fn {x, y} -> x < 50 && y < 50 end)
    |> Enum.count()
  end

  def beam(drone) do
    natural_number = Stream.iterate(0, &(&1 + 1))

    Stream.transform(natural_number, 0, fn x, start_y ->
      # it accumes the slope of the beam
      start = if beam_at?(drone, {x, start_y}), do: start_y, else: start_y + 1

      beam_row =
        start
        |> Stream.iterate(&(&1 + 1))
        |> Stream.map(&{x, &1})
        |> Stream.take_while(&beam_at?(drone, &1))
        |> Enum.to_list()

      {beam_row, start}
    end)
  end

  defp beam_at?(drone, {x, y}) do
    %{outputs: [output]} = IntcodeMachine.run(%{drone | inputs: [x, y]})
    output == 1
  end
end

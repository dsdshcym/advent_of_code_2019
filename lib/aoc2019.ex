defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  defmodule Image do
    defstruct [:width, :height, :layers]

    defmodule Layer do
      defstruct [:width, :height, :pixels]

      def new(pixels, width, height) do
        %__MODULE__{pixels: pixels, width: width, height: height}
      end

      def pixels_count(layer, pixel) do
        layer.pixels
        |> Enum.count(&Kernel.==(pixel, &1))
      end
    end

    def new(pixels, width, height) do
      layers =
        pixels
        |> Enum.chunk_every(width * height)
        |> Enum.map(&Layer.new(&1, width, height))

      %__MODULE__{layers: layers, width: width, height: height}
    end
  end

  def p1(input, width, height) do
    image =
      input
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Image.new(width, height)

    layer =
      image.layers
      |> Enum.min_by(&Image.Layer.pixels_count(&1, 0))

    Image.Layer.pixels_count(layer, 1) * Image.Layer.pixels_count(layer, 2)
  end
end

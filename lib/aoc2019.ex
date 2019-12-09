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

      def overlay(bottom, top) do
        %__MODULE__{
          pixels: overlay_pixels(bottom.pixels, top.pixels),
          width: bottom.width,
          height: bottom.height
        }
      end

      defp overlay_pixels([], []), do: []
      defp overlay_pixels([bh | br], [2 | tr]), do: [bh | overlay_pixels(br, tr)]
      defp overlay_pixels([_ | br], [th | tr]), do: [th | overlay_pixels(br, tr)]

      def to_string(layer) do
        layer.pixels
        |> Enum.chunk_every(layer.width)
        |> Enum.map(&Enum.join/1)
        |> Enum.join("\n")
      end
    end

    def new(pixels, width, height) do
      layers =
        pixels
        |> Enum.chunk_every(width * height)
        |> Enum.map(&Layer.new(&1, width, height))

      %__MODULE__{layers: layers, width: width, height: height}
    end

    def render(image) do
      layer =
        image.layers
        |> Enum.reduce(&Layer.overlay/2)

      %__MODULE__{layers: [layer], width: image.width, height: image.height}
    end

    def to_string(%__MODULE__{layers: [layer]}) do
      Layer.to_string(layer)
    end
  end

  def p1(input, width, height) do
    image =
      input
      |> string_to_digits()
      |> Image.new(width, height)

    layer =
      image.layers
      |> Enum.min_by(&Image.Layer.pixels_count(&1, 0))

    Image.Layer.pixels_count(layer, 1) * Image.Layer.pixels_count(layer, 2)
  end

  def p2(input, width, height) do
    input
    |> string_to_digits
    |> Image.new(width, height)
    |> Image.render()
    |> Image.to_string()
  end

  @doc """
  iex> AoC2019.string_to_digits("")
  []

  iex> AoC2019.string_to_digits("123")
  [1, 2, 3]

  iex> AoC2019.string_to_digits("003")
  [0, 0, 3]
  """
  def string_to_digits(string) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end

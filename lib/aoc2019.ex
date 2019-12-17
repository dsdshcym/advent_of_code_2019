defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def to_menu(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line(line) do
    [materials, product] = String.split(line, " => ")

    materials = materials |> String.split(", ") |> Enum.map(&parse_quantity_chemical/1)

    {product, quantity} = parse_quantity_chemical(product)

    {{product, quantity}, materials}
  end

  def parse_quantity_chemical(string) do
    [quantity, chemical] = String.split(string, " ")
    {chemical, String.to_integer(quantity)}
  end
end

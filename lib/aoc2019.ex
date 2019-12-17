defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    input
    |> to_menu()
    |> to_digraph()
    |> ore_required()
  end

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

  def to_digraph(menu) do
    digraph = :digraph.new()

    for {{product, p_qty}, materials} <- menu do
      :digraph.add_vertex(digraph, product)

      for {material, m_qty} <- materials do
        :digraph.add_vertex(digraph, material)

        :digraph.add_edge(digraph, product, material, {p_qty, m_qty})
      end
    end

    digraph
  end

  def ore_required(digraph, init_requirements \\ 1) do
    digraph
    |> :digraph_utils.topsort()
    |> Enum.reduce(%{"FUEL" => init_requirements}, fn product, requirements ->
      rp = Map.fetch!(requirements, product)

      digraph
      |> :digraph.out_edges(product)
      |> Enum.map(&:digraph.edge(digraph, &1))
      |> Enum.reduce(requirements, fn {_e, ^product, material, {qp, qm}}, requirements ->
        rm = ceil(rp / qp) * qm

        Map.update(requirements, material, rm, &(&1 + rm))
      end)
    end)
    |> Map.get("ORE")
  end
end

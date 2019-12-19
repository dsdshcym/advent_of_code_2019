defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    init =
      input
      |> parse()

    bfs([%{pos: init.entrance, collected_keys: MapSet.new(), step: 0}], init.map, init.keys)
  end

  def bfs(queue, map, keys, visited \\ MapSet.new())

  def bfs([current | rest], map, keys, visited) do
    cond do
      MapSet.equal?(current.collected_keys, keys) ->
        current.step - 1

      MapSet.member?(visited, {current.pos, current.collected_keys}) ->
        bfs(rest, map, keys, visited)

      blocked?(map, current.pos, current.collected_keys) ->
        bfs(rest, map, keys, visited)

      true ->
        current =
          case map[current.pos] do
            {:key, key} ->
              update_in(current.collected_keys, &MapSet.put(&1, key))

            _ ->
              current
          end

        nexts =
          for neighbor <- neighbors(current.pos) do
            current
            |> update_in([:step], &(&1 + 1))
            |> put_in([:pos], neighbor)
          end

        visited = MapSet.put(visited, {current.pos, current.collected_keys})

        bfs(rest ++ nexts, map, keys, visited)
    end
  end

  defp blocked?(map, pos, collected_keys) do
    case map[pos] do
      :wall -> true
      {:door, door} -> !MapSet.member?(collected_keys, to_key(door))
      {:key, _} -> false
      :open -> false
    end
  end

  defp to_key(door) do
    door - (?A - ?a)
  end

  defp neighbors({x, y}) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y}
    ]
  end

  def parse(input, pos \\ {0, 0}, state \\ %{map: %{}, keys: MapSet.new()})

  def parse('', _pos, state), do: state

  def parse([?. | tail], pos, state),
    do: parse(tail, next_cell(pos), put_in(state.map[pos], :open))

  def parse([?# | tail], pos, state),
    do: parse(tail, next_cell(pos), put_in(state.map[pos], :wall))

  def parse([?\n | tail], pos, state), do: parse(tail, next_line(pos), state)

  def parse([door | tail], pos, state) when door in ?A..?Z,
    do: parse(tail, next_cell(pos), put_in(state.map[pos], {:door, door}))

  def parse([key | tail], pos, state) when key in ?a..?z do
    new_state =
      state
      |> put_in([:map, pos], {:key, key})
      |> update_in([:keys], &MapSet.put(&1, key))

    parse(tail, next_cell(pos), new_state)
  end

  def parse([?@ | tail], pos, state) do
    new_state =
      state
      |> put_in([:map, pos], :open)
      |> put_in([:entrance], pos)

    parse(tail, next_cell(pos), new_state)
  end

  defp next_cell({x, y}), do: {x + 1, y}
  defp next_line({_, y}), do: {0, y + 1}
end

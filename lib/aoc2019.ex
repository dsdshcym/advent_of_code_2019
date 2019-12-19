defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  def p1(input) do
    m = IntcodeMachine.parse(input)

    {step, _machine} = bfs([%{status: 1, pos: {0, 0}, machine: m, step: 0}], MapSet.new())

    step
  end

  def p2(input) do
    m = IntcodeMachine.parse(input)

    {_step, machine} = bfs([%{status: 1, pos: {0, 0}, machine: m, step: 0}], MapSet.new())

    fill([%{status: 2, time: 0, pos: {0, 0}, machine: machine}], MapSet.new(), 0)
  end

  def bfs([%{status: 2} = current | _], _), do: {current.step, current.machine}

  def bfs([%{status: 0} | rest], visited), do: bfs(rest, visited)

  def bfs([current | rest], visited) do
    if MapSet.member?(visited, current.pos) do
      bfs(rest, visited)
    else
      next_robots =
        for direction <- 1..4,
            new_pos = move(current.pos, direction),
            {:await_on_input, machine} =
              IntcodeMachine.run(%{current.machine | inputs: [direction]}),
            [status] = machine.outputs do
          %{
            current
            | step: current.step + 1,
              pos: new_pos,
              status: status,
              machine: %{machine | outputs: []}
          }
        end

      bfs(rest ++ next_robots, MapSet.put(visited, current.pos))
    end
  end

  def fill([], _, time), do: time
  def fill([%{status: 0} | rest], visited, time), do: fill(rest, visited, time)

  def fill([current | rest], visited, time) do
    if MapSet.member?(visited, current.pos) do
      fill(rest, visited, time)
    else
      next_oxygens =
        for direction <- 1..4,
            new_pos = move(current.pos, direction),
            {:await_on_input, machine} =
              IntcodeMachine.run(%{current.machine | inputs: [direction]}),
            [status] = machine.outputs do
          %{
            current
            | time: current.time + 1,
              pos: new_pos,
              status: status,
              machine: %{machine | outputs: []}
          }
        end

      fill(rest ++ next_oxygens, MapSet.put(visited, current.pos), max(time, current.time))
    end
  end

  def move({x, y}, 1), do: {x, y - 1}
  def move({x, y}, 2), do: {x, y + 1}
  def move({x, y}, 3), do: {x - 1, y}
  def move({x, y}, 4), do: {x + 1, y}
end

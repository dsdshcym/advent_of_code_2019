defmodule PaintingRobot do
  defstruct panels: %{}, position: {0, 0}, direction: {0, 1}

  def p1(input) do
    computer = IntcodeMachine.parse(input)

    robot =
      new(%{})
      |> run(computer)

    robot.panels
    |> Map.keys()
    |> Enum.count()
  end

  def p2(input) do
    computer = IntcodeMachine.parse(input)

    robot =
      new(%{{0, 0} => 1})
      |> run(computer)

    robot.panels
    |> to_s()
  end

  defp to_s(panels) do
    {min_x, max_x} = panels |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = panels |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()

    for y <- max_y..min_y do
      for x <- min_x..max_x do
        case Map.get(panels, {x, y}, 0) do
          0 -> " "
          1 -> "*"
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def new(panels) do
    %__MODULE__{panels: panels}
  end

  def run(robot, computer) do
    case computer
         |> put_input(get_color(robot))
         |> IntcodeMachine.run() do
      {:await_on_input, computer} ->
        {[color, turn_direction], computer} = get_output(computer)

        robot
        |> paint(color)
        |> turn(turn_direction)
        |> move_forward()
        |> run(computer)

      {:halt, _} ->
        robot
    end
  end

  defp put_input(computer, input) do
    %{computer | inputs: [input]}
  end

  defp get_output(computer) do
    {computer.outputs, %{computer | outputs: []}}
  end

  defp get_color(robot) do
    Map.get(robot.panels, robot.position, 0)
  end

  defp paint(robot, color) do
    put_in(robot.panels[robot.position], color)
  end

  defp turn(robot, turn_direction) do
    %{robot | direction: update_direction(robot.direction, turn_direction)}
  end

  defp move_forward(robot) do
    %{robot | position: move(robot.position, robot.direction)}
  end

  defp update_direction({0, 1}, 0), do: {-1, 0}
  defp update_direction({-1, 0}, 0), do: {0, -1}
  defp update_direction({0, -1}, 0), do: {1, 0}
  defp update_direction({1, 0}, 0), do: {0, 1}

  defp update_direction({0, 1}, 1), do: {1, 0}
  defp update_direction({1, 0}, 1), do: {0, -1}
  defp update_direction({0, -1}, 1), do: {-1, 0}
  defp update_direction({-1, 0}, 1), do: {0, 1}

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}
end

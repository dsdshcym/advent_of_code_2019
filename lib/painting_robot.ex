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

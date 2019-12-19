defmodule AoC2019 do
  @moduledoc """
  Documentation for AoC2019.
  """

  defmodule Moon do
    @enforce_keys [:position]
    defstruct position: nil, velocity: %{x: 0, y: 0, z: 0}

    def new(line) when is_binary(line) do
      ["x=" <> x_str, "y=" <> y_str, "z=" <> z_str] =
        String.split(line, ["<", ",", " ", ">"], trim: true)

      new({String.to_integer(x_str), String.to_integer(y_str), String.to_integer(z_str)})
    end

    def new({x, y, z}) do
      %__MODULE__{position: %{x: x, y: y, z: z}}
    end

    def new({x, y, z}, {vx, vy, vz}) do
      %__MODULE__{
        position: %{x: x, y: y, z: z},
        velocity: %{x: vx, y: vy, z: vz}
      }
    end

    def apply_gravity(moon, other) do
      moon
      |> update_velocity(other, :x)
      |> update_velocity(other, :y)
      |> update_velocity(other, :z)
    end

    defp update_velocity(moon, other, dimension) do
      %{
        moon
        | velocity:
            Map.update!(
              moon.velocity,
              dimension,
              &(&1 - compare(moon.position[dimension], other.position[dimension]))
            )
      }
    end

    defp compare(d1, d2) when d1 < d2, do: -1
    defp compare(d1, d2) when d1 == d2, do: 0
    defp compare(d1, d2) when d1 > d2, do: 1

    def apply_velocity(moon) do
      moon
      |> apply_velocity(:x)
      |> apply_velocity(:y)
      |> apply_velocity(:z)
    end

    defp apply_velocity(moon, dimension) do
      %{
        moon
        | position: Map.update!(moon.position, dimension, &(&1 + moon.velocity[dimension]))
      }
    end

    def total_energy(moon) do
      potential_energy(moon) * kinetic_energy(moon)
    end

    defp potential_energy(moon) do
      moon.position
      |> Map.values()
      |> Enum.map(&abs/1)
      |> Enum.sum()
    end

    defp kinetic_energy(moon) do
      moon.velocity
      |> Map.values()
      |> Enum.map(&abs/1)
      |> Enum.sum()
    end
  end

  def p1(input, steps) do
    input
    |> parse()
    |> run(steps)
    |> Enum.map(&Moon.total_energy/1)
    |> Enum.sum()
  end

  def p2(input) do
    moons = parse(input)

    stream = stream(moons)

    ~w/x y z/a
    |> Enum.map(&cycle_time(moons, stream, &1))
    |> lcm()
  end

  def parse(input) do
    input
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&Moon.new/1)
  end

  def cycle_time(moons, stream, dimension) do
    stream
    |> Stream.drop(1)
    |> Enum.find_index(fn new_moons ->
      new_moons
      |> Enum.zip(moons)
      |> Enum.all?(fn {a, b} ->
        a.position[dimension] == b.position[dimension] &&
          a.velocity[dimension] == b.velocity[dimension]
      end)
    end)
    |> Kernel.+(1)
  end

  def lcm([a]), do: a
  def lcm([a, b | rest]), do: lcm([div(a * b, Integer.gcd(a, b)) | rest])

  def run(moons, step) do
    moons |> stream() |> Enum.at(step)
  end

  def stream(moons) do
    Stream.iterate(moons, &(&1 |> apply_gravities() |> apply_velocities()))
  end

  def apply_gravities(moons) do
    moons
    |> Enum.map(fn moon ->
      moons
      |> List.delete(moon)
      |> Enum.reduce(moon, fn other, moon -> Moon.apply_gravity(moon, other) end)
    end)
  end

  def apply_velocities(moons) do
    Enum.map(moons, &Moon.apply_velocity/1)
  end
end

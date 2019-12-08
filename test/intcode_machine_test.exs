defmodule IntcodeMachineTest do
  use ExUnit.Case, async: true

  @input "3,225,1,225,6,6,1100,1,238,225,104,0,1102,83,20,225,1102,55,83,224,1001,224,-4565,224,4,224,102,8,223,223,101,5,224,224,1,223,224,223,1101,52,15,225,1102,42,92,225,1101,24,65,225,101,33,44,224,101,-125,224,224,4,224,102,8,223,223,1001,224,7,224,1,223,224,223,1001,39,75,224,101,-127,224,224,4,224,1002,223,8,223,1001,224,3,224,1,223,224,223,2,14,48,224,101,-1300,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1002,139,79,224,101,-1896,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1102,24,92,225,1101,20,53,224,101,-73,224,224,4,224,102,8,223,223,101,5,224,224,1,223,224,223,1101,70,33,225,1101,56,33,225,1,196,170,224,1001,224,-38,224,4,224,102,8,223,223,101,4,224,224,1,224,223,223,1101,50,5,225,102,91,166,224,1001,224,-3003,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1107,677,677,224,1002,223,2,223,1006,224,329,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,344,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,359,101,1,223,223,107,677,677,224,1002,223,2,223,1006,224,374,1001,223,1,223,1007,677,677,224,102,2,223,223,1006,224,389,101,1,223,223,108,677,226,224,102,2,223,223,1006,224,404,101,1,223,223,1108,226,677,224,102,2,223,223,1005,224,419,1001,223,1,223,7,677,226,224,102,2,223,223,1005,224,434,101,1,223,223,1008,677,677,224,102,2,223,223,1006,224,449,1001,223,1,223,1007,677,226,224,1002,223,2,223,1006,224,464,101,1,223,223,1108,677,677,224,1002,223,2,223,1005,224,479,1001,223,1,223,107,226,226,224,1002,223,2,223,1005,224,494,101,1,223,223,8,226,677,224,102,2,223,223,1006,224,509,101,1,223,223,8,677,677,224,102,2,223,223,1006,224,524,101,1,223,223,1007,226,226,224,1002,223,2,223,1006,224,539,1001,223,1,223,107,677,226,224,102,2,223,223,1006,224,554,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,569,1001,223,1,223,1008,226,677,224,102,2,223,223,1006,224,584,1001,223,1,223,1008,226,226,224,1002,223,2,223,1005,224,599,1001,223,1,223,7,677,677,224,1002,223,2,223,1005,224,614,1001,223,1,223,1108,677,226,224,1002,223,2,223,1005,224,629,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,644,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,659,101,1,223,223,108,226,226,224,102,2,223,223,1005,224,674,101,1,223,223,4,223,99,226"

  describe "parse/1" do
    test "returns a values by address map" do
      assert IntcodeMachine.parse("3,225,1,225") ==
               {0, %{0 => 3, 1 => 225, 2 => 1, 3 => 225}, [1], []}
    end
  end

  describe "step/1" do
    test "plus" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1, 2, 3, 0])))

      assert ip == 4
      assert memory == build(:memory, [3, 2, 3, 0])
    end

    test "plus with immediate mode" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1101, 30, 23, 0])))

      assert ip == 4
      assert memory == build(:memory, [53, 30, 23, 0])
    end

    test "multiply" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 1, build(:memory, [0, 2, 2, 3, 0])))

      assert ip == 5
      assert memory == build(:memory, [6, 2, 2, 3, 0])
    end

    test "multiply with immediate mode" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1102, 3, 13, 0])))

      assert ip == 4
      assert memory == build(:memory, [39, 3, 13, 0])
    end

    test "input" do
      {:ok, {ip, memory, rest_inputs, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [3, 1]), [30, 2]))

      assert ip == 2
      assert memory == build(:memory, [3, 30])
      assert rest_inputs == [2]
    end

    test "output" do
      {:ok, {ip, memory, _, new_output}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [4, 0]), [], [2]))

      assert ip == 2
      assert memory == build(:memory, [4, 0])
      assert new_output == [2, 4]
    end

    test "jump-if-true" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [5, 2, 0]), [1], [2]))

      assert ip == 3
      assert memory == build(:memory, [5, 2, 0])

      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [105, 2, 0]), [1], [2]))

      assert ip == 105
      assert memory == build(:memory, [105, 2, 0])
    end

    test "jump-if-false" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [6, 2, 0]), [1], [2]))

      assert ip == 6
      assert memory == build(:memory, [6, 2, 0])

      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1106, 2, 0]), [1], [2]))

      assert ip == 3
      assert memory == build(:memory, [1106, 2, 0])
    end

    test "less than" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1107, 2, 0, 1]), [1], [2]))

      assert ip == 4
      assert memory == build(:memory, [1107, 0, 0, 1])

      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1107, -2, 0, 2]), [1], [2]))

      assert ip == 4
      assert memory == build(:memory, [1107, -2, 1, 2])
    end

    test "equals" do
      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1108, 0, 0, 2]), [1], [2]))

      assert ip == 4
      assert memory == build(:memory, [1108, 0, 1, 2])

      {:ok, {ip, memory, _, _}} =
        IntcodeMachine.step(build(:simulator, 0, build(:memory, [1108, 3, 0, 1]), [1], [2]))

      assert ip == 4
      assert memory == build(:memory, [1108, 0, 0, 1])
    end
  end

  describe "new/1" do
    test "part 1" do
      output = IntcodeMachine.new(@input).([1])
      assert List.last(output) == 12_428_642
    end

    test "part 2" do
      assert [1] = IntcodeMachine.new("3,9,8,9,10,9,4,9,99,-1,8").([8])

      assert [0] = IntcodeMachine.new("3,9,8,9,10,9,4,9,99,-1,8").([2])

      assert [1] = IntcodeMachine.new("3,9,7,9,10,9,4,9,99,-1,8").([7])

      assert [0] = IntcodeMachine.new("3,9,7,9,10,9,4,9,99,-1,8").([8])

      assert [1] = IntcodeMachine.new("3,3,1108,-1,8,3,4,3,99").([8])

      assert [0] = IntcodeMachine.new("3,3,1108,-1,8,3,4,3,99").([9])

      assert [1] = IntcodeMachine.new("3,3,1107,-1,8,3,4,3,99").([6])

      assert [0] = IntcodeMachine.new("3,3,1107,-1,8,3,4,3,99").([8])

      assert [999] =
               IntcodeMachine.new(
                 "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
               ).([7])

      assert [1000] =
               IntcodeMachine.new(
                 "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
               ).([8])

      assert [1001] =
               IntcodeMachine.new(
                 "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
               ).([9])

      assert [918_655] = IntcodeMachine.new(@input).([5])
    end
  end

  def build(:memory, list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {value, address} -> {address, value} end)
    |> Map.new()
  end

  def build(:simulator, ip, memory, input \\ [], output \\ []) do
    {ip, memory, input, output}
  end
end

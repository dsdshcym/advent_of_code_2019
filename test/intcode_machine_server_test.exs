defmodule IntcodeMachineServerTest do
  use ExUnit.Case, async: true

  test "input / output" do
    assert_result("3,9,8,9,10,9,4,9,99,-1,8", 8, 1)
    assert_result("3,9,8,9,10,9,4,9,99,-1,8", 2, 0)

    assert_result("3,9,7,9,10,9,4,9,99,-1,8", 7, 1)
    assert_result("3,9,7,9,10,9,4,9,99,-1,8", 8, 0)

    assert_result(
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99",
      7,
      999
    )

    assert_result(
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99",
      8,
      1000
    )

    assert_result(
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99",
      9,
      1001
    )
  end

  def assert_result(memory, input, output) do
    Process.flag(:trap_exit, true)
    {:ok, machine} = IntcodeMachineServer.start_link(memory)

    IntcodeMachineServer.connect_to(machine, self())
    IntcodeMachineServer.run(machine)
    IntcodeMachineServer.output_to(machine, input)

    assert_receive({:"$gen_cast", {:output, ^output, ^machine}})
    assert_receive({:EXIT, _, :normal})
  end
end

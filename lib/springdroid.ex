defmodule Springdroid do
  @jump_to_d '''
  NOT A J
  NOT B T
  OR T J
  NOT C T
  OR T J
  AND D J
  WALK
  '''

  def p1(input) do
    m = IntcodeMachine.parse(input)
    m = IntcodeMachine.run(%{m | inputs: @jump_to_d})

    {_prompts, [hull_damage]} = Enum.split(m.outputs, -1)

    hull_damage
  end
end

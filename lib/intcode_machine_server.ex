defmodule IntcodeMachineServer do
  use GenServer

  def start_link(input, initial_inputs \\ []) do
    {ip, memory, _, _} = IntcodeMachine.parse(input)

    GenServer.start_link(__MODULE__, {ip, memory, initial_inputs})
  end

  def connect_to(machine, another_machine) do
    GenServer.cast(machine, {:connect_to, another_machine})
  end

  def run(machine) do
    GenServer.cast(machine, :run)
  end

  def output_to(machine, value) do
    GenServer.cast(machine, {:output, value})
  end

  @impl true
  def init({ip, memory, inputs}) do
    {:ok,
     %{
       ip: ip,
       memory: memory,
       inputs: inputs,
       output_targets: []
     }}
  end

  @impl true
  def handle_cast({:connect_to, another_machine}, %{output_targets: output_targets} = state) do
    {:noreply, %{state | output_targets: [another_machine | output_targets]}}
  end

  def handle_cast({:output, value}, %{input_callback: input_callback} = state) do
    {new_ip, new_memory} = input_callback.(value)

    do_run(%{state | ip: new_ip, memory: new_memory, input_callback: nil})
  end

  def handle_cast(:run, state) do
    do_run(state)
  end

  defp do_run(state) do
    case IntcodeMachine.step({state.ip, state.memory, state.inputs, []}) do
      {:ok, {new_ip, new_memory, new_inputs, []}} ->
        do_run(%{state | ip: new_ip, memory: new_memory, inputs: new_inputs})

      {:output, {new_ip, new_memory, new_inputs, [output]}} ->
        for target <- state.output_targets do
          output_to(target, output)
        end

        do_run(%{state | ip: new_ip, memory: new_memory, inputs: new_inputs})

      {:await_on_input, input_callback} ->
        {:noreply, Map.put(state, :input_callback, input_callback)}

      {:halt, {new_ip, new_memory, inputs, []}} ->
        {:stop, :normal, %{state | ip: new_ip, memory: new_memory, inputs: inputs}}
    end
  end
end

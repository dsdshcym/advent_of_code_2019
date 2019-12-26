defmodule IntcodeMachineServer do
  use GenServer

  def start_link(input, initial_inputs \\ []) do
    machine = IntcodeMachine.parse(input, initial_inputs)

    GenServer.start_link(__MODULE__, machine)
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
  def init(machine) do
    {:ok, %{machine: machine, output_targets: []}}
  end

  @impl true
  def handle_cast({:connect_to, another_machine}, %{output_targets: output_targets} = state) do
    {:noreply, %{state | output_targets: [another_machine | output_targets]}}
  end

  def handle_cast({:output, value}, state) do
    do_run(update_in(state.machine.inputs, &List.flatten([&1 | [value]])))
  end

  def handle_cast(:run, state) do
    do_run(state)
  end

  defp do_run(state) do
    case IntcodeMachine.step(state.machine) do
      {:ok, new_machine} ->
        do_run(%{state | machine: new_machine})

      {:output, new_machine} ->
        output = List.last(new_machine.outputs)

        for target <- state.output_targets do
          output_to(target, output)
        end

        do_run(%{state | machine: new_machine})

      {:await_on_input, new_machine} ->
        {:noreply, %{state | machine: new_machine}}

      {:halt, new_machine} ->
        {:stop, :normal, %{state | machine: new_machine}}
    end
  end
end

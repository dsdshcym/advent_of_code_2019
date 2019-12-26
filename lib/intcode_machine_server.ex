defmodule IntcodeMachineServer do
  use GenServer

  def start_link(input, initial_inputs \\ []) do
    machine = IntcodeMachine.parse(input, initial_inputs)

    GenServer.start_link(__MODULE__, machine)
  end

  def connect_to(machine, another_machine) do
    GenServer.cast(machine, {:connect_to, another_machine})
  end

  def input_from(machine, another_machine) do
    GenServer.cast(machine, {:input_from, another_machine})
  end

  def run(machine) do
    GenServer.cast(machine, :run)
  end

  def output_to(machine, value) do
    GenServer.cast(machine, {:output, value, self()})
  end

  @impl true
  def init(machine) do
    {:ok, %{machine: machine, output_targets: [], input_froms: []}}
  end

  @impl true
  def handle_cast({:connect_to, another_machine}, %{output_targets: output_targets} = state) do
    {:noreply, %{state | output_targets: [another_machine | output_targets]}}
  end

  def handle_cast({:input_from, another_machine}, %{input_froms: input_froms} = state) do
    {:noreply, %{state | input_froms: [another_machine | input_froms]}}
  end

  def handle_cast({:output, value, _from}, state) do
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
        {:message_queue_len, len} = Process.info(self(), :message_queue_len)

        if len == 0 do
          for from <- state.input_froms do
            GenServer.cast(from, {:await_on_input, self()})
          end
        end

        {:noreply, %{state | machine: new_machine}}

      {:halt, new_machine} ->
        {:stop, :normal, %{state | machine: new_machine}}
    end
  end
end

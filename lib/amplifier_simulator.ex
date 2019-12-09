defmodule AmplifierSimulator do
  use GenServer

  def start_link(input, phase_settings) do
    GenServer.start_link(__MODULE__, {input, phase_settings})
  end

  def result(simulator) do
    GenServer.call(simulator, :result, :infinity)
  end

  @impl true
  def init({input, phase_settings}) do
    Process.flag(:trap_exit, true)

    amplifiers =
      Enum.map(phase_settings, fn phase_setting ->
        {:ok, amplifier} = IntcodeMachineServer.start_link(input, [phase_setting])
        amplifier
      end)

    a0 = List.first(amplifiers)
    a4 = List.last(amplifiers)

    amplifiers
    |> Enum.chunk_every(2, 1, [a0])
    |> Enum.map(fn [from, to] -> IntcodeMachineServer.connect_to(from, to) end)

    IntcodeMachineServer.connect_to(a4, self())

    amplifiers
    |> Enum.map(&IntcodeMachineServer.run(&1))

    IntcodeMachineServer.output_to(a0, 0)

    {:ok, %{amplifiers: amplifiers, outputs: []}}
  end

  @impl true
  def handle_call(:result, _from, %{amplifiers: [], outputs: [last_output | _]} = state) do
    {:reply, last_output, state}
  end

  def handle_call(:result, from, state) do
    {:noreply, Map.put_new(state, :requester, from)}
  end

  @impl true
  def handle_cast({:output, value}, %{outputs: outputs} = state) do
    {:noreply, %{state | outputs: [value | outputs]}}
  end

  @impl true
  def handle_info({:EXIT, amplifier, :normal}, %{amplifiers: amplifiers} = state) do
    new_amplifiers = List.delete(amplifiers, amplifier)
    new_state = %{state | amplifiers: new_amplifiers}

    maybe_reply(new_state)
  end

  defp maybe_reply(%{amplifiers: [], requester: requester, outputs: [last_output | _]} = state) do
    GenServer.reply(requester, last_output)
    {:noreply, state}
  end

  defp maybe_reply(state) do
    {:noreply, state}
  end
end

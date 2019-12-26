defmodule Network do
  use GenServer

  @impl true
  def init(code) do
    {:ok, %{packet_by_senders: %{}, computers: nil}, {:continue, {:init_computers, code}}}
  end

  @impl true
  def handle_continue({:init_computers, code}, state) do
    computers =
      for i <- 0..49, into: %{} do
        {:ok, c} = IntcodeMachineServer.start_link(code, [i])
        IntcodeMachineServer.connect_to(c, self())
        IntcodeMachineServer.input_from(c, self())
        IntcodeMachineServer.run(c)

        {i, c}
      end

    {:noreply, %{state | computers: computers}}
  end

  @impl true
  def handle_cast({:output, value, from}, state) do
    case Map.get(state.packet_by_senders, from, []) do
      [255, _x] ->
        IO.inspect(value)

        {:noreply,
         state
         |> put_in([:packet_by_senders, from], [])
         |> put_in([:nat_memory], value)}

      [] ->
        {:noreply, put_in(state.packet_by_senders[from], [value])}

      [target] ->
        {:noreply, put_in(state.packet_by_senders[from], [target, value])}

      [target, x] ->
        y = value
        target = Map.fetch!(state.computers, target)
        IntcodeMachineServer.output_to(target, [x, y])
        {:noreply, put_in(state.packet_by_senders[from], [])}
    end
  end

  def handle_cast({:await_on_input, pid}, state) do
    if !any_packet_for?(state, pid), do: IntcodeMachineServer.output_to(pid, -1)

    {:noreply, state}
  end

  defp any_packet_for?(state, pid) do
    {target, _} = Enum.find(state.computers, fn {_i, computer} -> computer == pid end)

    Enum.find(state.packet_by_senders, fn
      {_, [^target | _]} -> true
      _ -> false
    end)
  end
end

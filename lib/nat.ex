defmodule NAT do
  use GenServer

  @impl true
  def init(code) do
    {:ok, %{packet_by_senders: %{}, idled_pids: Map.new(), computers: nil, nat_memory: nil},
     {:continue, {:init_computers, code}}}
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
      [255, x] ->
        state =
          state
          |> update_in([:packet_by_senders], &Map.delete(&1, from))
          |> put_in([:nat_memory], [x, value])
          |> throttle_if_idle()

        {:noreply, state}

      [] ->
        {:noreply, put_in(state.packet_by_senders[from], [value])}

      [target] ->
        {:noreply, put_in(state.packet_by_senders[from], [target, value])}

      [target, x] ->
        y = value
        send_packet(state, target, [x, y])

        {:noreply,
         state
         |> update_in([:packet_by_senders], &Map.delete(&1, from))
         |> put_in([:idled_pids, Map.fetch!(state.computers, target)], 0)}
    end
  end

  def handle_cast({:await_on_input, pid}, state) do
    state = throttle_if_idle(state)

    state =
      if !any_packet_for?(state, pid) do
        IntcodeMachineServer.output_to(pid, -1)
        update_in(state.idled_pids, &Map.update(&1, pid, 1, fn count -> count + 1 end))
      else
        put_in(state.idled_pids[pid], 0)
      end

    {:noreply, state}
  end

  defp any_packet_for?(state, pid) do
    {target, _} = Enum.find(state.computers, fn {_i, computer} -> computer == pid end)

    Enum.find(state.packet_by_senders, fn
      {_, [^target | _]} -> true
      _ -> false
    end)
  end

  defp throttle_if_idle(state) do
    if Enum.empty?(state.packet_by_senders) &&
         map_size(state.idled_pids) == map_size(state.computers) &&
         Enum.all?(state.idled_pids, fn {_pid, count} -> count > 0 end) &&
         state.nat_memory do
      IO.inspect(state.nat_memory)
      send_packet(state, 0, state.nat_memory)
      put_in(state.idled_pids, Map.new())
    else
      state
    end
  end

  defp send_packet(state, target, packet) do
    state.computers
    |> Map.fetch!(target)
    |> IntcodeMachineServer.output_to(packet)
  end
end

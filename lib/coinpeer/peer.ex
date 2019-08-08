defmodule Coinpeer.Peer do
  alias Coinpeer.Msg
  require Logger

  @peer %{
    state: :start,
    socket: nil,
    receiver: nil,
    net: nil,
    buffer: <<>>
  }

  @doc """

  """
  def start(ip, net, receiver) do
    {:ok, socket} = :gen_tcp.connect(ip, Coinpeer.Net.port(net), [:binary, {:packet, 0}, {:active, false}])
    loop(%{@peer|socket: socket, state: :start, receiver: receiver, net: net})
  end

  defp loop(p = %{state: :start}) do
    send_msg(p, Msg.new(p.net, :version))
    loop(%{p|state: :version_sent})
  end

  defp loop(p = %{state: :version_sent}) do
    {:ok, b} = :gen_tcp.recv(p.socket, 0, 50*1000)
    loop(%{p|state: :listen, buffer: b})
  end

  defp loop(p = %{state: :listen}) do
    case Msg.unmake(p.buffer, p.net) do
      {:ok, cmd, payload} ->
        data = Msg.parse_payload(cmd, payload)
        Logger.debug("[SV-node] #{cmd} #{data}")
        handle_cmd(cmd, data, p)
        loop(%{p|buffer: <<>>})
      {:error, :incomplete} ->
        {:ok, b} = :gen_tcp.recv(p.socket, 0, 120*1000) # waitting for new msg or rest part of big msg
        buffer = p.buffer
        loop(%{p|buffer: <<buffer::bytes, b::bytes>>})
    end
  end

  defp send_msg(p, msg) do
    {:ok, cmd, payload} = Msg.unmake(msg, p.net)
    data = Msg.parse_payload(cmd, payload)
    Logger.debug("[Coinpeer] #{cmd} #{data}")
    :gen_tcp.send(p.socket, msg)
  end

  defp handle_cmd("version", _, p) do
    send_msg(p, Msg.new(p.net, :verack))
  end

  defp handle_cmd(cmd, _, _) do
    IO.inspect cmd, label: "cmd"
    "TODO"
  end
end
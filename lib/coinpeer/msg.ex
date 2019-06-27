defmodule Coinpeer.Msg do
  alias Coinpeer.Varstr
  alias Coinpeer.Crypto
  alias Coinpeer.Net
  alias Coinpeer.Util

  @protocol_version 31800

  def new(net, cmd, params \\ []) do
    payload = apply(__MODULE__, cmd, params)
    make_msg(net, cmd, payload)
  end

  def version do
    services = <<1, 0::7*8>>
    timestamp = Util.timestamp()
    addr_recv = <<services::binary, 0::80, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0>>
    addr_from = addr_recv
    nonce = :crypto.strong_rand_bytes(8)
    user_agnet = Varstr.new(<<"\r/Coinpeer v0.1/">>)
    start_height = 0

    <<@protocol_version::32-little,
      services::binary,
      timestamp::64-little,
      addr_recv::binary,
      addr_from::binary,
      nonce::binary,
      user_agnet::binary,
      start_height::32-little>>
  end

  def verack, do: <<>>

  defp make_msg(net, cmd, payload) do
    magic = Net.magic(net)
    size = byte_size(payload)
    checksum = get_checksum(payload)
    cmd_bin = atom_to_binary_cmd(cmd)
    <<magic::32-big, cmd_bin::binary, size::32-little,
      checksum::binary, payload::binary>>
  end

  defp get_checksum(bin) do
    <<c::4-bytes, _::bytes>> = Crypto.hash256(bin) # double hash
    c
  end

  defp atom_to_binary_cmd(atom) do
    s = Atom.to_string(atom)
    l = (12 - byte_size(s)) * 8
    <<s::binary, 0::size(l)>>
  end

  defp binary_cmd_to_string(cmd) do
    :erlang.binary_to_list(cmd)
    |> :string.strip(:right, 0)
    |> to_string()
  end

  def unmake(<<magic::32-big, cmd::12-bytes, size::32-little-integer, checksum::4-bytes, payload::size(size)-bytes, _rest::bytes>>, net) do
    ^magic = Net.magic(net)
    ^checksum = get_checksum(payload)
    {:ok, binary_cmd_to_string(cmd), payload}
  end

  def unmake(data, _network) do
    {:error, :incomplete}
  end

  def parse_payload("version", _) do
    "TODO"
  end

  def parse_payload(_, _) do
    "TODO"
  end
end
defmodule Coinpeer do
  @moduledoc """
  The `Coinpeer` module provides peer-to-peer net connection
  to a bitcoinsv node.
  """

  @doc """
  mount to a bitcoinsv node to receive latest transactions.
  """
  def mount(opts) do
    network = Keyword.get(opts, :network) || :mainnet
    case network do
      :mainnet -> mount()
      :stn ->
        mount('178.128.58.114', :stn)
    end
  end

  def mount(ip \\ '138.197.220.146', net \\ :mainnet) do
    spawn_link(fn -> Coinpeer.Peer.start(ip, net, self()) end)
  end


end

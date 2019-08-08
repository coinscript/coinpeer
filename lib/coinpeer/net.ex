defmodule Coinpeer.Net do

  def magic(:mainnet), do: 0xE3E1F3E8
  def magic(:stn), do: 0xfbcec4f9

  def port(:mainnet), do: 8333
  def port(:stn), do: 9333
end
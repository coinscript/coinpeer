defmodule Coinpeer.Crypto do

  def hash256(x) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, x))
  end

  def hash160(x) do
    :crypto.hash(:ripemd160, :crypto.hash(:sha256, x))
  end
end
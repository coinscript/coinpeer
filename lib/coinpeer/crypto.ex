defmodule Coinpeer.Crypto do

  def hash256(x) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, x))
  end
end
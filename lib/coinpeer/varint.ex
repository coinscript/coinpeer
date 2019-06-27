defmodule Coinpeer.Varint do

  def new(x) when x < 0xfd, do: <<x>>
  def new(x) when x <= 0xffff, do: <<0xfd, x::16-little>>
  def new(x) when x <= 0xffffffff, do: <<0xfe, x::32-little>>
  def new(x) when x <= 0xffffffffffffffff, do: <<0xff, x::64-little>>

end
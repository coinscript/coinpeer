defmodule Coinpeer.Varstr do
  alias Coinpeer.Varint

  def new(bin) do
    len = Varint.new(byte_size(bin))
    <<len::binary, bin::binary>>
  end

end
defmodule Coinpeer.Tx do
  defstruct do
    [
      txins: [],
      txouts: [],
      locktime: 0
    ]
  end
end
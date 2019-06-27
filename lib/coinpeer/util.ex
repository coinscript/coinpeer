defmodule Coinpeer.Util do

  def timestamp do
    {a, b, _} = :os.timestamp()
    a*1000000 + b
  end
end
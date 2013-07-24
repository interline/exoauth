defmodule OAuth2.Utils.UUID do
	use Bitwise
  def v4 do
    :random.seed :erlang.now
    part = fn(bits) -> :random.uniform(trunc(:math.pow(2, bits))) - 1 end
    y = part.(4)
    y = bor(band(y, 3), 8)
    <<f::size(32), s::size(16), t::size(16), r::size(16), v::size(48)>> = <<part.(48) :: size(48), 4 :: size(4), part.(12) :: size(12), y :: size(4), part.(60) :: size(60)>>
    :erlang.iolist_to_binary(:io_lib.format("~.16b-~.16b-~.16b-~.16b-~.16b", [f,s,t,r,v]))
  end
end
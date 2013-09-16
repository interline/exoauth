defmodule OAuth2.Utils.UUID do
  @compile :native

  use Bitwise

  def v4 do
    <<s0::32, s1::16, s2::12, s3::30, s4::32, _::6>> = :crypto.rand_bytes(16)
    <<s2::16, s3::16, s4::48>> = <<4::4, s2::12, 2::2, s3::30, s4::32>>
    iolist_to_binary [ hex(s0), ?-, hex(s1), ?-, hex(s2), ?-, hex(s3), ?-, hex(s4) ]
  end

  defp hex(n), do: hex(n, [])

  defp hex(0, acc), do: acc
  defp hex(n, acc) do
    hex(n >>> 4, [ acc, hex_digit(n &&& 0x0f) ])
  end

  Enum.each 0..15, fn (n) ->
    if n < 10 do
      defp hex_digit(unquote(n)), do: unquote(?0 + n)
    else
      defp hex_digit(unquote(n)), do: unquote(?a + (n - 10))
    end
  end
end


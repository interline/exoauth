Code.require_file "test_helper.exs", __DIR__

defmodule BasicAuthTest do
  use ExUnit.Case
  alias HTTP.Auth.Basic, as: Basic

  test :decode do
    assert {"Aladdin", "open sesame"} == Basic.decode("QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
  end

  test :encode do
    assert "QWxhZGRpbjpvcGVuIHNlc2FtZQ==" == Basic.encode("Aladdin", "open sesame")
  end

  test :decode_bad_data do
  	invalid_hash = :base64.encode("foo")
  	assert :invalid_credentials == Basic.decode(invalid_hash)
	end
end

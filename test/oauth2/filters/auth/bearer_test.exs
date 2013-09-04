Code.require_file "../../../test_helper.exs", __DIR__
Code.require_file "../../../mock/services.exs", __DIR__

defmodule OAuth2.Filters.Auth.BearerTest do
  defmodule Endpoint do
    use Dynamo.Router
    filter OAuth2.Filters.Auth.Bearer.new(MockService)

    get "/" do
      conn
    end
  end

  Dynamo.under_test(Endpoint)

	use ExUnit.Case, async: true
  use Dynamo.HTTP.Case

  test "bearer token sent in is the access_token we get back" do
    conn = bearer_request("abc123")
    conn = service(conn)
    assert conn.private[:token].access_token == "abc123"
  end

  test "unknown bearer token returns 401" do
    conn = bearer_request("123abc")
    { :halt!, conn } = catch_throw(service(conn))
    assert conn.status == 401
  end

  defp bearer_request(token) when is_binary(token) do
    conn = conn(:GET, "/")
    conn.put_req_header "authorization", "Bearer " <> token
  end

  defp service(conn), do: @endpoint.service(conn)
end


Code.require_file "../test_helper.exs", __DIR__
Code.require_file "../mock/services.exs", __DIR__


defmodule OAuth2.TokenEndpointTest do
	defmodule Endpoint do
		use OAuth2.TokenEndpoint, service: MockService
	end

	Dynamo.under_test(Endpoint)

	use ExUnit.Case, async: true
  use Dynamo.HTTP.Case

  test "content type must be application/x-www-form-urlencoded" do
    conn = conn(:POST, "/", "")
    conn = service(conn)
    json = get_json(conn)
    assert "invalid_request" == json["error"]
    assert "content type must be application/x-www-form-urlencoded" == json["error_description"]
  end

  test "request must have a client_id" do
    conn = conn(:POST, "/", "foo")
    conn = put_content_type_header(conn)
    conn = service(conn)
    json = get_json(conn)
    assert "invalid_request" == json["error"]
    assert "request must have a client_id" == json["error_description"]
  end

  test "request must have a grant_type" do
    conn = conn(:POST, "/?client_id=foo", "")
    conn = put_content_type_header(conn)
    conn = service(conn)
    json = get_json(conn)
    assert "invalid_request" == json["error"]
    assert "request must have a grant_type" == json["error_description"]
  end

  test "pull client id from authentication header" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=password", "")
    conn = put_content_type_header(conn)
    conn = put_authorization_header(conn, "client", "sekret")
    conn = service(conn)
    json = get_json(conn)
    assert "request must have a client_id" != json["error_description"]
    assert conn.status == 400
  end

  test "password grant with basic authentication header" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=password&username=user&password=secret", "")
    conn = put_content_type_header(conn)
    conn = put_authorization_header(conn, "client", "sekret")
    conn = service(conn)
    json = get_json(conn)
    assert !nil?(json["access_token"])
    assert conn.status == 200
  end

  test "password grant with all params in request" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=password&client_id=client&client_secret=sekret&username=user&password=secret", "")
    conn = put_content_type_header(conn)
    conn = service(conn)
    json = get_json(conn)
    assert conn.status == 200
    assert !nil?(json["access_token"])
  end

  test "client_credentials grant with basic authentication header" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=client_credentials", "")
    conn = put_content_type_header(conn)
    conn = put_authorization_header(conn, "client", "sekret")
    conn = service(conn)
    json = get_json(conn)
    assert !nil?(json["access_token"])
    assert conn.status == 200
  end

  test "client credentials grant with all params in request" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=client_credentials&client_id=client&client_secret=sekret", "")
    conn = put_content_type_header(conn)
    conn = service(conn)
    json = get_json(conn)
    assert conn.status == 200
    assert !nil?(json["access_token"])
  end

  test "refresh token grant with basic authentication header" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=refresh_token&refresh_token=refresh-token", "")
    conn = put_content_type_header(conn)
    conn = put_authorization_header(conn, "client", "sekret")
    conn = service(conn)
    json = get_json(conn)
    assert !nil?(json["access_token"])
    assert conn.status == 200
  end

  test "refresh token grant with all params in request" do
    # send params through the query string because test connection does not
    # parse and decode post body when fetching params
    conn = conn(:POST, "/?grant_type=refresh_token&refresh_token=refresh-token&client_id=client&client_secret=sekret", "")
    conn = put_content_type_header(conn)
    conn = service(conn)
    json = get_json(conn)
    assert conn.status == 200
    assert !nil?(json["access_token"])
  end

	defp service(conn), do: @endpoint.service conn
  
  defp get_json(conn) do
    content_type = conn.resp_headers["Content-Type"]
    assert !nil?(content_type)
    assert String.contains?(content_type, "application/json")
    { :ok, body } = conn.resp_body
    { :ok, json } = JSON.decode(body)
    json
  end
  
  defp put_authorization_header(conn, username, password) do
    auth = "Basic " <> OAuth2.HTTP.Auth.Basic.encode(username, password)
    conn.put_req_header("Authorization", auth)
  end

  defp put_content_type_header(conn) do
    conn.put_req_header("Content-Type", "application/x-www-form-urlencoded")
  end
end

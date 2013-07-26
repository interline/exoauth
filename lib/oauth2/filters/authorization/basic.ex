defmodule OAuth2.Filters.Authorization.Basic do
  def service(conn, fun) do
    conn = conn.fetch([:headers, :params])
    headers = conn.req_headers
    if Dict.has_key?(headers, "authorization") do
      client_from_header(headers["authorization"], conn, fun)
    else
      fun.(conn)
    end
  end

  defp client_from_header("Basic " <> header, conn, fun) do
    case HTTP.Auth.Basic.decode(header) do
      { id, secret } ->
        fun.(conn
              .assign(:client_id, id)
              .assign(:client_secret, secret))
      :invalid_credentials ->
        conn
          .status(400)
          .resp_body [ error: :invalid_credentials, error_description: "malformed basic authorization header" ]
    end
  end

  defp client_from_header(_header, conn, fun), do: fun.(conn)
end
defmodule OAuth2.Filters.Auth.Bearer do
  import Dynamo.HTTP.Halt

  def new(service) do
    { __MODULE__, service }
  end

  def service(conn, fun, { __MODULE__, service }) do
    conn = conn.fetch(:headers)
    headers = conn.req_headers
    auth_header = headers["authorization"] || unauthorized(conn)
    authenticate(auth_header, service, conn, fun)
  end

  defp authenticate("Bearer " <> token, service, conn, fun) do
    case service.access_token(token) do
      { :error, :unauthorized_client } ->
        unauthorized(conn)
      access_token ->
        conn = conn.put_private :token, access_token
        fun.(conn)
    end
  end

  defp authenticate(_header, _service, conn, _fun), do: unauthorized(conn)

  defp unauthorized(conn), do: halt! conn.status(401)
end


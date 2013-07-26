defmodule OAuth2.Filters.GrantType do
  def service(conn, fun) do
    conn = conn.fetch(:params)
    unless Dict.has_key?(conn.params, "grant_type") do
      conn
        .status(400)
        .resp_body [ error: :invalid_request, error_description: "request must have a grant_type" ]
    else
      fun.(conn)
    end
  end
end
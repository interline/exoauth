defmodule OAuth2.Filters.ContentType do
  def service(conn, fun) do
    conn = conn.fetch(:headers)
    content_type = conn.req_headers["content-type"]
    if nil?(content_type) || !String.contains?(content_type, "application/x-www-form-urlencoded") do
      error = [ error: :invalid_request, error_description: "content type must be application/x-www-form-urlencoded" ]
      conn
        .status(400)
        .resp_body(error)
    else
      fun.(conn)
    end
  end
end
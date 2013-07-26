defmodule OAuth2.Filters.ClientId do
  def service(conn, fun) do
    if conn.assigns[:client_id] do
      fun.(conn)
    else
      conn = conn.fetch([:body, :params])
      params = conn.params
      if Dict.has_key?(params, "client_id") do
        fun.(conn.assign(:client_id, params["client_id"]))
      else
        conn
          .status(400)
          .resp_body([ error: :invalid_request, error_description: "request must have a client_id" ]) 
      end
    end
  end
end
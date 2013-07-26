defmodule OAuth2.Filters.NoCache do
  def finalize(conn) do
    conn
      .put_resp_header("Cache-Control", "no-store")
      .put_resp_header("Pragma", "no-cache")
  end
end
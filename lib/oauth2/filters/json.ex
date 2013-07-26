defmodule OAuth2.Filters.Json do
  @default_encoder JSON

  def new(encoder // @default_encoder) do
    { __MODULE__, encoder }
  end

  def finalize(conn) do
    finalize(conn, { __MODULE__, @default_encoder })
  end

  def finalize(conn, { __MODULE__, encoder }) do
    conn = conn.put_resp_header "Content-Type", "application/json; charset=utf-8"
    conn.resp_body apply(encoder, :encode, [ conn.resp_body ])
  end
end
defmodule OAuth2.TokenEndpoint do
  defmacro __using__(opts) do
    service = Keyword.fetch!(opts, :service)

    quote location: :keep do
      use Dynamo.Router
      alias OAuth2.AccessToken
      alias OAuth2.Filters

      filter Filters.NoCache
      filter Filters.Json.new
      filter Filters.ContentType
      filter Filters.Auth.Basic
      filter Filters.ClientId
      filter Filters.GrantType

      post "/" do
        conn = var!(conn)

        params = 
          Enum.map conn.params, fn { k, v } -> 
            { binary_to_existing_atom(k), v }
          end

        unless Dict.has_key?(params, :client_id) do
          params = Dict.put(params, :client_id, conn.assigns[:client_id])
        end

        unless Dict.has_key?(params, :client_secret) do
          params = Dict.put(params, :client_secret, conn.assigns[:client_secret])
        end

        { status, resp } = 
          case unquote(service).grant_access(params) do
            AccessToken[] = token -> { 200, token_response(token) }
            { :error, error }     -> { 400, error_response(error) }
          end

        conn
          .status(status)
          .resp_body(resp)
      end

      def token_response(token) do
        token.to_keywords
      end

      @doc "override this to add error_uri"
      def error_response(error) do
        error_description = unquote(service).error_description(error)

        unless nil? error_description do
          resp = [ error_description: error_description ]
        end

        error_uri = error_uri(error)
        unless nil? error_uri do
          resp = resp || [ error_uri: error_uri ]
        end

        [ error: error ] || resp
      end

      def error_uri(error), do: nil

      defoverridable [ token_response: 1, error_response: 1, error_uri: 1 ]
    end
  end
end

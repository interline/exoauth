# RFC 6749

defmodule OAuth2.Service do
  use Behaviour

  defmacro __using__(_opts) do
    quote do
      @behaviour OAuth2.Service
      import OAuth2.Service

      def grant_access(opts) do
        try do
          grant_type    = Keyword.fetch!(opts, :grant_type)
          client_id     = Keyword.fetch!(opts, :client_id)
          client_secret = Keyword.fetch!(opts, :client_secret)
          if authenticate_client?(client_id, client_secret) do
            grant_access(grant_type, opts)
          else
            :invalid_client
          end
        rescue
          [ KeyError ] -> :invalid_request
        end
      end

      def grant_access(:password, opts) do
        username = Keyword.fetch!(opts, :username)
        password = Keyword.fetch!(opts, :password)
        if authenticate_user?(username, password) do
          client = Keyword.get(opts, :client_id)
          scope  = Keyword.get(opts, :scope)
          key    = generate_token(client, username, scope)
          assign_access_token to: client, for: username, with: scope
        else
          :invalid_credentials
        end
      end

      def grant_access(:client_credentials, opts) do
        client = opts[:client_id]
        scope  = opts[:scope]
        key    = generate_token(client, nil, scope)
        assign_access_token to: client, for: nil, with: scope
      end

      def generate_token(_client, _user, _scope) do
        OAuth2.Utils.UUID.v4
      end

      defoverridable [ generate_token: 3 ]
    end
  end

  @doc "authenticates a client id/secret pair"
  defcallback authenticate_client?(id :: binary, secret :: binary | nil) :: true | false

  @doc "authenticates a username/password pair"
  defcallback authenticate_user?(username :: binary, password :: binary) :: true | false

  @doc "creates an access token bound to the client and user [ and scope if provided ]"
  defcallback assign_access_token(to: client :: binary, for: user :: binary, with: scope :: binary | nil) :: OAuth2.AccessToken.t
end

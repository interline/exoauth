defmodule MockService do
	use OAuth2.Service

	alias OAuth2.AccessToken, as: Token

	def authenticate_user?("user", "secret"), do: true
	def authenticate_user?(_, _), do: false

	def authenticate_client?("client", "sekret"), do: true
	def authenticate_client?(_, _), do: false

  def access_token("abc123") do
    Token.new(access_token: "abc123")
  end

  def access_token(_token) do
    { :error, :unauthorized_client }
  end

	def assign_access_token(to: client, with: scope) do
		Token.new(access_token: generate_token(client, nil, scope))
	end

	def assign_access_token(to: client, for: user, with: scope) do
		Token.new(access_token: generate_token(client, user, scope))
	end

	def assign_access_token(to: client, via: _refresh_token, with: new_scope) do
		Token.new(access_token: generate_token(client, nil, new_scope))
	end
end

defmodule MockService2 do
	use OAuth2.Service

	alias OAuth2.AccessToken, as: Token

	def authenticate_user?("user", "secret"), do: true
	def authenticate_user?(_, _), do: false

	def authenticate_client?("client", "sekret"), do: true
	def authenticate_client?(_, _), do: false

  def access_token("abc123") do
    Token.new(access_token: "abc123")
  end

  def access_token(_token) do
    { :error, :unauthorized_client }
  end

	def assign_access_token(to: client, for: user, with: scope) do
		Token.new(access_token: generate_token(client, user, scope))
	end

	def assign_access_token(to: client, via: _refresh_token, with: new_scope) do
		Token.new(access_token: generate_token(client, nil, new_scope))
	end

	def generate_token(client, user, nil ) do
		client <> "!!" <> user
	end
end

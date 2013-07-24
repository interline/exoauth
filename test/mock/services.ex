defmodule MockService do
	use OAuth2.Service

	alias OAuth2.AccessToken, as: Token

	def authenticate_user?("user", "secret"), do: true
	def authenticate_user?(_, _), do: false

	def authenticate_client?("client", "sekret"), do: true
	def authenticate_client?(_, _), do: false

	def assign_access_token(to: client, for: user, with: scope) do
		Token.new(access_token: generate_token(client, user, scope))
	end
end

defmodule MockService2 do
	use OAuth2.Service

	alias OAuth2.AccessToken, as: Token

	def authenticate_user?("user", "secret"), do: true
	def authenticate_user?(_, _), do: false

	def authenticate_client?("client", "sekret"), do: true
	def authenticate_client?(_, _), do: false

	def assign_access_token(to: client, for: user, with: scope) do
		Token.new(access_token: generate_token(client, user, scope))
	end

	def generate_token(client, user, nil ) do
		client <> "!!" <> user
	end
end
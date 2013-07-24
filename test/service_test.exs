Code.require_file "test_helper.exs", __DIR__
Code.require_file "mock/services.ex", __DIR__

defmodule ServiceTest do
	use ExUnit.Case

	alias OAuth2.AccessToken

	test :overwritten_generate_token do
		successful_request = [ grant_type: :password, client_id: "client", client_secret: "sekret", username: "user", password: "secret" ]
		assert AccessToken[access_token: "client!!user"] = MockService2.grant_access(successful_request)
	end

	test :invalid_password_request do
		request = [ grant_type: :password ]
		assert :invalid_request == MockService.grant_access(request)
		
		request = Keyword.put request, :client_id, "client"
		assert :invalid_request == MockService.grant_access(request)
		
		request = Keyword.put request, :client_secret, "sekret"
		assert :invalid_request = MockService.grant_access(request)

		assert :invalid_request = MockService.grant_access(Keyword.put request, :username, "user")
		assert :invalid_request = MockService.grant_access(Keyword.put request, :password, "password")
	end

	test :password_grant do
		failing_request = [ grant_type: :password, client_id: "client", client_secret: "shh!" ]
		assert :invalid_client == MockService.grant_access(failing_request)

		successful_request = [ grant_type: :password, client_id: "client", client_secret: "sekret", username: "user", password: "secret", scope: "all" ]
		assert AccessToken[] = MockService.grant_access(successful_request)
	end

	test :client_credentials_grant do
		failing_request = [ grant_type: :client_credentials, client_id: "client" ]
		assert :invalid_request = MockService.grant_access(failing_request)

		successful_request = Keyword.put failing_request, :client_secret, "sekret"
		assert AccessToken[] = MockService.grant_access(successful_request)
	end

	test :refresh_token_grant do
		request = [ grant_type: :refresh_token, client_id: "client" ]
		assert :invalid_request = MockService.grant_access(request)

		request = Keyword.put request, :client_secret, "sekret"
		assert :invalid_request = MockService.grant_access(request)

		request = Keyword.put request, :refresh_token, "refresh-token"
		assert AccessToken[] = MockService.grant_access(request)
	end

	test :unsupported_grant_type do
		request = [ grant_type: :foo, client_id: "client", client_secret: "sekret" ]
		assert :unsupported_grant_type = MockService.grant_access(request)
	end
end



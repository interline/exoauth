defmodule HTTP.Auth.Basic do
  def decode(encoded) when is_binary(encoded) do
    parts = encoded 
    	|> :base64.decode
    	|> String.split(":")
    	|> Enum.map(URI.decode &1)
    
    destructure([ client_id, client_secret ], parts)
    
    case { client_id, client_secret } do
    	{ _, nil } -> :invalid_credentials
    	{ client_id, client_secret } -> { client_id, client_secret }
    end
  end
end

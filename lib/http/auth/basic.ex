defmodule HTTP.Auth.Basic do
  def encode(username, password) do
    :base64.encode(username <> ":" <> password)
  end

  def decode(encoded) when is_binary(encoded) do
    parts = encoded 
      |> :base64.decode
      |> String.split(":")
    
    destructure([ client_id, client_secret ], parts)
    
    case { client_id, client_secret } do
    	{ _, nil } -> :invalid_credentials
    	{ client_id, client_secret } -> { client_id, client_secret }
    end
  end
end

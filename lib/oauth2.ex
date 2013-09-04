defrecord OAuth2.AccessToken, access_token: nil, token_type: nil, client_id: nil, user_id: nil, scope: nil, expires_in: nil
defrecord OAuth2.RefreshToken, client_id: nil, user_id: nil, scope: nil

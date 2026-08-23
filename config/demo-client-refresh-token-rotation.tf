resource "keycloak_openid_client" "example-with-refresh-token-rotation" {
  realm_id                 = keycloak_realm.example.id
  client_id                = "example-client-with-refresh-token-rotation"
  name                     = "Example Client"
  enabled                  = true
  access_type              = "PUBLIC"
  standard_flow_enabled    = true

  valid_redirect_uris = [
    "http://localhost:9555/callback"
  ]

  extra_config = {
    "revoke.refresh.token" = true
  }
}

resource "keycloak_openid_client" "example-without-refresh-token-rotation" {
  realm_id                 = keycloak_realm.example.id
  client_id                = "example-client-without-refresh-token-rotation"
  name                     = "Example Client"
  enabled                  = true
  access_type              = "PUBLIC"
  standard_flow_enabled    = true

  valid_redirect_uris = [
    "http://localhost:9555/callback"
  ]

  extra_config = {
    "revoke.refresh.token" = false
  }
}

resource "random_password" "client_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "keycloak_openid_client" "example" {
  realm_id                 = keycloak_realm.example.id
  client_id                = "example-client"
  name                     = "Example Client"
  enabled                  = true
  access_type              = "CONFIDENTIAL"
  client_secret_wo         = random_password.client_secret.result
  client_secret_wo_version = 1
  standard_flow_enabled    = true

  valid_redirect_uris = [
    "https://example.com/callback",
  ]

  web_origins = [
    "https://example.com",
  ]
}
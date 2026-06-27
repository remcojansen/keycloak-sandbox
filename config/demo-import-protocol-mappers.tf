data "keycloak_openid_client_scope" "profile" {
  realm_id = keycloak_realm.example.id
  name     = "profile"
}

resource "keycloak_openid_user_attribute_protocol_mapper" "username" {
  realm_id        = keycloak_realm.example.id
  client_scope_id = data.keycloak_openid_client_scope.profile.id
  name            = "username"
  claim_name      = "preferred_username"
  user_attribute  = "username"
  import          = true
  add_to_id_token = false
}

resource "keycloak_openid_user_attribute_protocol_mapper" "given_name" {
  realm_id            = keycloak_realm.example.id
  client_scope_id     = data.keycloak_openid_client_scope.profile.id
  name                = "given name"
  claim_name          = "given_name"
  user_attribute      = "firstName"
  import              = true
  add_to_id_token     = false
  add_to_access_token = true
  add_to_userinfo     = false
}
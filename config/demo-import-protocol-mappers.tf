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
  add_to_id_token = false
}

import {
  to = keycloak_openid_user_attribute_protocol_mapper.username
  id = "${keycloak_realm.example.id}/client-scope/${data.keycloak_openid_client_scope.profile.id}/name/username"
}

resource "keycloak_openid_user_attribute_protocol_mapper" "given_name" {
  realm_id            = keycloak_realm.example.id
  client_scope_id     = data.keycloak_openid_client_scope.profile.id
  name                = "given name"
  claim_name          = "given_name"
  user_attribute      = "firstName"
  add_to_id_token     = false
  add_to_access_token = true
  add_to_userinfo     = false
}

import {
  to = keycloak_openid_user_attribute_protocol_mapper.given_name
  id = "${keycloak_realm.example.id}/client-scope/${data.keycloak_openid_client_scope.profile.id}/name/given%20name"
}
provider "keycloak" {
  client_id                = "admin-cli"
  url                      = var.keycloak_url
  username                 = var.keycloak_admin_user
  password                 = var.keycloak_admin_password
  tls_insecure_skip_verify = var.keycloak_tls_insecure_skip_verify
}

resource "keycloak_realm" "example" {
  realm        = var.realm_name
  enabled      = true
  display_name = "Example Realm"

  registration_allowed     = false
  login_with_email_allowed = true
  duplicate_emails_allowed = false
  reset_password_allowed   = true
  edit_username_allowed    = false
  remember_me              = true
  verify_email             = false

  security_defenses {
    brute_force_detection {
      permanent_lockout                = false
      brute_force_strategy             = "MULTIPLE"
      max_login_failures               = 5
      wait_increment_seconds           = 60
      quick_login_check_milli_seconds  = 1000
      minimum_quick_login_wait_seconds = 60
      max_failure_wait_seconds         = 900
      failure_reset_time_seconds       = 43200
    }
  }

}

resource "random_password" "client_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "keycloak_openid_client" "example" {
  realm_id      = keycloak_realm.example.id
  client_id     = "example-client"
  name          = "Example Client"
  enabled       = true
  access_type   = "CONFIDENTIAL"
  client_secret_wo = random_password.client_secret.result
  client_secret_wo_version = 1
  standard_flow_enabled = true

  valid_redirect_uris = [
    "https://example.com/callback",
  ]

  web_origins = [
    "https://example.com",
  ]
}
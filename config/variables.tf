variable "keycloak_url" {
  description = "Keycloak base URL"
  type        = string
  default     = "https://localhost:9443"
}

variable "keycloak_admin_user" {
  description = "Keycloak admin username"
  type        = string
  default     = "admin"
}

variable "keycloak_admin_password" {
  description = "Keycloak admin password"
  type        = string
  sensitive   = true
}

variable "keycloak_tls_insecure_skip_verify" {
  description = "Skip TLS verification (useful for local self-signed certs)"
  type        = bool
  default     = true
}

variable "realm_name" {
  description = "Realm name to create"
  type        = string
  default     = "example"
}

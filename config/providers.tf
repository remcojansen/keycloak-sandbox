terraform {
  required_version = ">= 1.5.0"

  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
      version = "5.8.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.9.0"
    }
  }
}
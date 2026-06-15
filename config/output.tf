output "example_client_secret" {
  description = "The client secret set on the example OpenID client."
  value       = random_password.client_secret.result
  sensitive   = true
}

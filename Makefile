.SILENT:

IAC_CMD := $(shell if command -v tofu >/dev/null 2>&1; then echo tofu; elif command -v terraform >/dev/null 2>&1; then echo terraform; fi)

.PHONY: up
up:
	bash ./scripts/generate-cert.sh
	docker compose up -d
	bash ./scripts/wait-for-local-keycloak.sh

.PHONY: up-rebuild
up-rebuild:
	bash ./scripts/generate-cert.sh
	docker compose build --no-cache keycloak
	docker compose up -d --force-recreate keycloak
	bash ./scripts/wait-for-local-keycloak.sh

.PHONY: config
config:
	if [ -z "$(IAC_CMD)" ]; then echo "Error: install OpenTofu (tofu) or Terraform (terraform)."; exit 1; fi
	cd terraform && $(IAC_CMD) init && $(IAC_CMD) apply

.PHONY: down
down:
	docker compose down

.PHONY: clean
clean:
	docker compose down -v
	rm -rf certs terraform/.terraform terraform/.terraform.lock.hcl terraform/terraform.tfstate terraform/terraform.tfstate.backup terraform/*.tfstate terraform/*.tfstate.* terraform/*.tfplan

.PHONY: help
.DEFAULT_GOAL := help

help:
	echo "Available targets:"
	echo "  make up         - Start containers and seed Vault"
	echo "  make up-rebuild - Rebuild Keycloak image (no cache) and restart container"
	echo "  make config     - Apply OpenTofu/Terraform configuration (prefers tofu)"
	echo "  make down       - Stop and remove containers"
	echo "  make clean      - Remove compose containers and IaC local state/artifacts"

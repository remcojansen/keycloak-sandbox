.SILENT:

SHELL := /bin/sh

COMPOSE_CMD ?= $(shell \
	if command -v docker >/dev/null 2>&1; then echo "docker compose"; \
	elif command -v podman >/dev/null 2>&1; then echo "podman compose"; \
	else echo ""; fi)

TF_CMD ?= $(shell \
	if command -v terraform >/dev/null 2>&1; then echo "terraform"; \
	elif command -v tofu >/dev/null 2>&1; then echo "tofu"; \
	else echo ""; fi)

CONFIG_DIR ?= config
PROVIDER_DIR ?= $(CONFIG_DIR)/provider
PROVIDER_CLI_CONFIG ?= $(CONFIG_DIR)/provider.tfrc
TF_ENV = TF_CLI_CONFIG_FILE=$(CURDIR)/$(PROVIDER_CLI_CONFIG) TOFU_CLI_CONFIG_FILE=$(CURDIR)/$(PROVIDER_CLI_CONFIG)

.PHONY: help
.DEFAULT_GOAL := help
help:
	@echo "Available targets:"
	@echo "  help     Show this help message"
	@echo "  up       Start services and apply Terraform/OpenTofu configuration"
	@echo "  config   Apply Terraform/OpenTofu configuration without starting services"
	@echo "  status   Show compose service status and port mappings"
	@echo "  fmt      Format Terraform/OpenTofu files in config/"
	@echo "  down     Stop services without removing volumes/images"
	@echo "  clean    Remove services, volumes, images, certs, and local Terraform/OpenTofu working state"

.PHONY: check-compose
check-compose:
	@if [ -z "$(COMPOSE_CMD)" ]; then \
		echo "No compose runtime found. Install docker or podman, or set COMPOSE_CMD=\"<compose command>\"."; \
		exit 1; \
	fi

.PHONY: check-tf
check-tf:
	@if [ -z "$(TF_CMD)" ]; then \
		echo "No IaC tool found. Install terraform or tofu, or set TF_CMD=\"<iac command>\"."; \
		exit 1; \
	fi

.PHONY: provider-cli-config
provider-cli-config:
	@if ls "$(PROVIDER_DIR)"/terraform-provider-keycloak* >/dev/null 2>&1; then \
		echo "Using local Keycloak provider from $(PROVIDER_DIR)."; \
		printf '%s\n' \
			'provider_installation {' \
			'  dev_overrides {' \
			'    "keycloak/keycloak" = "$(CURDIR)/$(PROVIDER_DIR)"' \
			'  }' \
			'  direct {}' \
			'}' \
			> "$(PROVIDER_CLI_CONFIG)"; \
	else \
		echo "Local provider not found in $(PROVIDER_DIR); falling back to registry provider (latest)."; \
		printf '%s\n' \
			'provider_installation {' \
			'  direct {}' \
			'}' \
			> "$(PROVIDER_CLI_CONFIG)"; \
	fi

.PHONY: generate-cert
generate-cert:
	bash ./scripts/generate-cert.sh

.PHONY: compose-up
compose-up: check-compose generate-cert
	$(COMPOSE_CMD) up -d
	bash ./scripts/wait-for-local-keycloak.sh

.PHONY: compose-up-rebuild
compose-up-rebuild: check-compose generate-cert
	${COMPOSE_CMD} build --no-cache keycloak
	${COMPOSE_CMD} up -d --force-recreate keycloak
	bash ./scripts/wait-for-local-keycloak.sh

.PHONY: config
config: check-tf provider-cli-config
	$(TF_ENV) $(TF_CMD) -chdir=$(CONFIG_DIR) init -upgrade
	$(TF_ENV) $(TF_CMD) -chdir=$(CONFIG_DIR) apply -auto-approve

.PHONY: up
up: compose-up config

.PHONY: up-rebuild
up-rebuild: compose-up-rebuild config

.PHONY: status
status: check-compose
	$(COMPOSE_CMD) ps

.PHONY: fmt
fmt: check-tf
	$(TF_CMD) -chdir=$(CONFIG_DIR) fmt -recursive

.PHONY: down
down: check-compose
	$(COMPOSE_CMD) down --remove-orphans

.PHONY: clean
clean: check-compose
	$(COMPOSE_CMD) down --volumes --rmi all --remove-orphans
	rm -f $(PROVIDER_CLI_CONFIG)
	rm -f $(CONFIG_DIR)/.terraform.lock.hcl $(CONFIG_DIR)/terraform.tfstate $(CONFIG_DIR)/terraform.tfstate.backup
	rm -rf $(CONFIG_DIR)/.terraform
	rm -rf certs/
# Keycloak Sandbox

A local Keycloak sandbox environment backed by PostgreSQL, with a Terraform/OpenTofu configuration for managing Keycloak resources.

## Overview

| Component | Details |
|-----------|---------|
| Keycloak  | `quay.io/keycloak/keycloak` — exposed on `https://localhost:9443` |
| PostgreSQL | `postgres:16-alpine` — used as the Keycloak database |
| IaC | Terraform / OpenTofu via the `keycloak/keycloak` provider |

## Prerequisites

- Docker or Podman (with Compose)
- Terraform ≥ 1.5.0 or OpenTofu

## Quick start

```bash
make up
```

This single command will:

1. Generate a self-signed TLS certificate under `certs/`.
2. Start Keycloak and PostgreSQL via Docker/Podman Compose.
3. Wait for Keycloak to become healthy.
4. Run `terraform init` / `tofu init` and apply the configuration in `config/`.

## Make targets

| Target    | Description |
|-----------|-------------|
| `help`    | Show available targets |
| `up`      | Start services and apply Terraform/OpenTofu configuration |
| `status`  | Show Compose service status and port mappings |
| `fmt`     | Format Terraform/OpenTofu files in `config/` |
| `down`    | Stop services without removing volumes or images |
| `destroy` | Destroy Terraform/OpenTofu resources and remove services, volumes, and images |

## Configuration

Terraform variables are read from `config/terraform.tfvars`. Copy the example file to get started:

```bash
cp config/terraform.tfvars.example config/terraform.tfvars
```

## What the Terraform configuration creates

- **Realm** — `keycloak_realm.example` with brute-force protection enabled.
- **OpenID client** — `example-client` (confidential, standard flow) with a randomly generated secret.

## Local provider override

If a locally built Keycloak provider binary is present in `config/provider/`, `make up` will configure Terraform/OpenTofu to use it via a dev override (`config/provider.tfrc`). Otherwise the registry version is used.

## Credentials

Default admin credentials (change these for anything beyond local development):

- **Username:** `admin`
- **Password:** `admin`

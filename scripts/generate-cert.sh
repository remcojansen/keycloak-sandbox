#!/bin/bash

# Generate self-signed certificate for Keycloak dev mode
CERT_DIR="certs"

if [ -f "$CERT_DIR/server.crt" ]; then
  echo "Certificate already exists at $CERT_DIR/server.crt"
  exit 0
fi

mkdir -p "$CERT_DIR"

openssl req -x509 -newkey rsa:2048 -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.crt" \
  -days 365 -nodes \
  -subj "/CN=localhost/O=Vault POC/C=US"

# Make certs group readable to allow reading inside a container when running as non-root
chmod 755 "$CERT_DIR"
chmod 644 "$CERT_DIR/server.key" "$CERT_DIR/server.crt"

echo "✓ Self-signed certificate generated at $CERT_DIR/"

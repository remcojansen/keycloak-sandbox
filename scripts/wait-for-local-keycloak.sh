#!/usr/bin/env bash

KEYCLOAK_URL="https://localhost:9443/"

printf "Waiting for local Keycloak to be ready"

until $(curl --output /dev/null --silent --head --fail --insecure --max-time 2 ${KEYCLOAK_URL}); do
    printf '.'
    sleep 2
done

echo

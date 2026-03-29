# Keycloak Extensions

Place your custom Keycloak SPI implementation sources under `extensions/src/main/java`.

This repository uses the root `pom.xml` to build a single extensions JAR that is copied into Keycloak's providers directory when building the Docker image.

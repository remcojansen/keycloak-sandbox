FROM docker.io/maven:3.9.11-eclipse-temurin-21 AS builder
WORKDIR /workspace

COPY pom.xml ./
COPY extensions ./extensions

RUN mvn --batch-mode --no-transfer-progress -DskipTests package

FROM quay.io/keycloak/keycloak:26.5.6
COPY --from=builder /workspace/target/*.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]

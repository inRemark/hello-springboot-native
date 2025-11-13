FROM ghcr.io/graalvm/native-image-community:25-ol9 AS builder

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /workspace

COPY mvnw .
COPY .mvn ./.mvn
COPY pom.xml .
COPY src ./src

RUN chmod +x mvnw
# Build Spring Boot native image for Linux; name the binary 'app'
RUN ./mvnw clean package -DskipTests

# ---- Runtime stage ----
FROM eclipse-temurin:21.0.9_10-jre-ubi10-minimal

WORKDIR /app
COPY --from=builder /workspace/target/*.jar ./app.jar

RUN groupadd -r spring && useradd -r -g spring spring
USER spring

EXPOSE 8080

# Define environment variable
ENV APP_HOME=/app
ENV SPRING_PROFILES_ACTIVE=prod
ENTRYPOINT ["java","-jar","-Xmx256m","-Xms256m","app.jar"]

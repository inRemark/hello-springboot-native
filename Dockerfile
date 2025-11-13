FROM eclipse-temurin:21.0.9_10-jdk-ubi10-minimal AS builder

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
USER 1001
COPY --from=builder --chown=1001:1001 /workspace/target/*.jar ./app.jar

EXPOSE 8080

# Define environment variable
ENV APP_HOME=/app \
    SPRING_PROFILES_ACTIVE=prod \
    JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS --spring.config.import=optional:/config/ -jar app.jar"]

#docker run -p 8080:8080 -v $(pwd)/config:/config -e SPRING_PROFILES_ACTIVE=prod boot-native:latest

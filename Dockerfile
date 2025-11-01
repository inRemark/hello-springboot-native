FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

ARG JAR_FILE
COPY ${JAR_FILE} app.jar

RUN groupadd -r spring && useradd -r -g spring spring
USER spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

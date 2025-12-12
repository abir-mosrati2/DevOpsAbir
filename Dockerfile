FROM openjdk:17.0.1-jdk-slim
WORKDIR /app

# Copier le JAR généré par Maven
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8089
ENTRYPOINT ["java", "-jar", "/app.jar"]

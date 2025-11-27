# Use a lightweight Java runtime
FROM eclipse-temurin:17-jre-alpine

# Create app directory
WORKDIR /app

# Copy the jar
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Run the app as root
ENTRYPOINT ["java", "-jar", "app.jar"]

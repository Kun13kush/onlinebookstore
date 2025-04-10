# Stage 1: Build the application
FROM maven:3.8.5-openjdk-11-slim AS build

# Set working directory
WORKDIR /app

# Copy Maven build files
COPY pom.xml ./
COPY src ./src
COPY WebContent ./WebContent

# Build the project
RUN mvn clean package

# Stage 2: Create the runtime image
FROM openjdk:11-jdk-slim

# Set working directory
WORKDIR /app

# Copy the WAR file and webapp-runner from the build stage
COPY --from=build /app/target/onlinebookstore.war ./onlinebookstore.war
COPY --from=build /app/target/dependency/webapp-runner.jar ./webapp-runner.jar

# Expose the webapp-runner port
EXPOSE 8080

# Start the app using embedded Tomcat
CMD ["java", "-jar", "webapp-runner.jar", "onlinebookstore.war"]
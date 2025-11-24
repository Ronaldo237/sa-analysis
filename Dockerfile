# ---------- STAGE 1 : BUILD ----------
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app

# Copier le pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier tout le projet et builder
COPY src ./src
RUN mvn clean package -DskipTests -B


# ---------- STAGE 2 : RUNTIME ----------
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]

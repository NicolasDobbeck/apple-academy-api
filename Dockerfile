# Etapa de build
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copia o pom.xml e o código-fonte para otimizar o cache do Docker
COPY pom.xml .
COPY src ./src

# Dá permissão de execução ao Maven wrapper e compila o projeto
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests

# Etapa de execução
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copia o .jar do build
COPY --from=builder /app/target/*.jar app.jar

# Expõe a porta padrão
EXPOSE 8080

# Comando para rodar o app
ENTRYPOINT ["java", "-jar", "app.jar"]
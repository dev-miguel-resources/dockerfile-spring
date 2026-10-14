# Dockerfile3 + jlink (peso: 134 MB)

# ========================
# Etapa 1: BUILD
# ========================

FROM maven:3.9.9-eclipse-temurin-21-alpine AS build

WORKDIR /app

COPY pom.xml .

RUN mvn -B -q -DskipTests dependency:go-offline

COPY src ./src

# RUN mvn clean package -DskipTests -Dspring-boot.aot.skip=true
RUN mvn clean package -DskipTests

# ========================
# JLINK STAGE (JVM)
# ========================

FROM eclipse-temurin:21-jdk-alpine AS jre-build
# Imagen ligera de un JDK con alpine
# Esta imagen te permite optimizar y personalizar el código interno utilizado para la ejecución
# Optimizar el código que ocupa la JVM (java virtual machine)

# Instalar el gestor jlink del proveedor binutils para JVM
RUN apk add --no-cache binutils

# Crear una JVM personalizada con lo mínimo
RUN $JAVA_HOME/bin/jlink \
    --add-modules java.base,java.logging,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /jre

# ========================
# RUNTIME FINAL
# ========================

FROM alpine:3.24

WORKDIR /app

# Copiamos la JVM optimizada desde el stage anterior
COPY --from=jre-build /jre /opt/jre

# Agregar esa JVM copiada a un ENV de ejecuciones para Java
# para permitir ejecutar el "java" interno de esa carpeta
ENV PATH="/opt/jre/bin:$PATH"

COPY wait-for-db.sh /wait-for-db.sh

RUN chmod +x /wait-for-db.sh

# ========================
# COPIAR EL JAR
# ========================

COPY --from=build /app/target/*.jar app.jar

# ========================
# PUERTO
# ========================

EXPOSE 8080

# ========================
# ENTRYPOINT
# ========================

ENTRYPOINT [ "sh", "-c", "\
    export SPRING_DATASOURCE_USERNAME=$(cat /run/secrets/mysql_user) && \
    export SPRING_DATASOURCE_PASSWORD=$(cat /run/secrets/mysql_pass) && \
    exec /wait-for-db.sh mysql 3306 java -jar app.jar \
    "]


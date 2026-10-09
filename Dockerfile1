# Dockerfile 1 con corretto jdk (peso: 386MB)

# ========================
# Etapa 1: BUILD
# ========================

FROM maven:3.9.9-eclipse-temurin-21-alpine AS build
# - Maven 3.9.9: gestor de paquetes y necesario para la compilación
# - Java 21 Temurin: (Procesamiento óptimo binario para compilación, distribución de OpenJDK)
# - AS build: Nombre que se le da a la etapa, el cual te sirve para luego referenciarlo desde este archivo

# Define el directorio de trabajo para la imagen dentro del contenedor
WORKDIR /app

# Copiamos el archivo de dependencias en nuestro directorio de trabajo
COPY pom.xml .

# Descargar los paquetes necesarios para que mi app funcione
RUN mvn -B -q -DskipTests dependency:go-offline
# -B: modo batch
# -q: detección limpia de proceso terminado
# -DskipTests: para que no considere el entorno de dependencias de tests
# dependency:go-offline: modo de verificación de caché de dependencias

# Copiamos el código fuente dentro de una carpeta src dentro de app
COPY src ./src

# Compilar mi app y generar mi archivo .jar
RUN mvn clean package -DskipTests
# /app/target/*.jar

# ========================
# Etapa 2: RUNTIME (FINAL)
# ========================
FROM amazoncorretto:21-alpine-jdk
# Imagen ligera solo para producción y ejecución
# No incluyen Maven -> reduce el tamaño y superficie de ataque
# Basadas en alpine (muy livianas) y auditadas con baja tasa de vulnerabilidad vs otras imagenes

WORKDIR /app

# Copiar un script que se encargue de esperar a la que la bdd este disponible para recibir conexiones
# Evitar que la app falle por arranques propios de MYSQL
COPY wait-for-db.sh /wait-for-db.sh

# Damos los permisos necesarios para la ejecución del script
RUN chmod +x /wait-for-db.sh

# ========================
# COPIAR EL JAR
# ========================

# Copiamos sl el artefacto generado desde la etapa build
# No copia código fuente ni maven
COPY --from=build /app/target/*.jar app.jar

# ========================
# PUERTOS
# ========================

# Documentar el puerto desde el cual se expone mi app de Spring
EXPOSE 8080

# ========================
# ENTRYPOINT
# ========================
ENTRYPOINT [ "sh", "-c", "\
    export SPRING_DATASOURCE_USERNAME=$(cat /run/secrets/mysql_user) && \
    export SPRING_DATASOURCE_PASSWORD=$(cat /run/secrets/mysql_pass) && \
    exec /wait-for-db.sh mysql 3306 java -jar app.jar \
    "]
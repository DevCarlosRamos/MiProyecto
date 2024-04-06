# Usa una imagen base de Maven para construir el proyecto
FROM maven:3.8.5-openjdk-11-slim AS build

# Copia el código fuente del proyecto al contenedor
COPY . /usr/src/app

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Construye el proyecto Maven
RUN mvn clean package

# Usa una imagen base de OpenJDK 11 para ejecutar la aplicación
FROM openjdk:11-jre-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia el archivo JAR generado durante la fase de construcción al contenedor
COPY --from=build /usr/src/app/target/MiProyecto-1.0-SNAPSHOT.jar /usr/src/app/MiProyecto.jar

# Indica que el contenedor escuchará en el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación cuando se inicie el contenedor
CMD ["java", "-jar", "MiProyecto.jar"]
# Usa una imagen base de OpenJDK 11
FROM openjdk:11-jre-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia el archivo JAR desde el directorio target a /usr/src/app en el contenedor
COPY target/MiProyecto-1.0-SNAPSHOT.jar /usr/src/app/MiProyecto.jar

# Indica que el contenedor escuchará en el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación cuando se inicie el contenedor
CMD ["java", "-jar", "MiProyecto.jar"]

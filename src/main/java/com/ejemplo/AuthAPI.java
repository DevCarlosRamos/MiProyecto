package com.ejemplo;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import spark.Request;
import spark.Response;
import static spark.Spark.*;

public class AuthAPI {

    // Ruta al archivo JSON donde se guardarán los usuarios y contraseñas
    private static final String RUTA_USUARIOS = "usuarios.json";

    // ObjectMapper para serializar y deserializar objetos Java a/desde JSON
    private static final ObjectMapper mapper = new ObjectMapper();

    public static void main(String[] args) {
        // Configuración del puerto en el que se ejecutará el servidor
        port(8080);

        // Configurar las rutas de la API
        post("/registro", AuthAPI::registro);
        post("/login", AuthAPI::login);

        // Inicializar el archivo JSON de usuarios si no existe
        File archivo = new File(RUTA_USUARIOS);
        if (!archivo.exists()) {
            try {
                archivo.createNewFile();
                // Si no existe, crear un archivo vacío y escribir un objeto JSON vacío
                mapper.writeValue(archivo, new HashMap<>());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // Método para manejar las solicitudes de registro de nuevos usuarios
    private static Object registro(Request req, Response res) throws IOException {
        // Convertir el cuerpo de la solicitud JSON a un mapa de Java
        JavaType type = mapper.getTypeFactory().constructMapType(HashMap.class, String.class, String.class);
        Map<String, String> requestBody = mapper.readValue(req.body(), type);

        // Obtener el usuario y la contraseña del cuerpo de la solicitud
        String usuario = requestBody.get("usuario");
        String contraseña = requestBody.get("contraseña");

        // Leer el mapa de usuarios desde el archivo JSON
        Map<String, String> usuarios = mapper.readValue(new File(RUTA_USUARIOS), type);

        // Verificar si el usuario ya existe en el mapa
        if (usuarios.containsKey(usuario)) {
            // Si el usuario ya existe, devolver un mensaje de error y establecer el código
            // de estado 400 (Bad Request)
            res.status(400);
            return "El usuario ya existe";
        }

        // Agregar el nuevo usuario al mapa de usuarios
        usuarios.put(usuario, contraseña);
        // Escribir el mapa de usuarios actualizado en el archivo JSON
        mapper.writeValue(new File(RUTA_USUARIOS), usuarios);

        // Establecer el código de estado 201 (Created) para indicar que el usuario se
        // ha creado correctamente
        res.status(201);
        return "Usuario creado exitosamente";
    }

    // Método para manejar las solicitudes de inicio de sesión
    private static Object login(Request req, Response res) throws IOException {
        // Convertir el cuerpo de la solicitud JSON a un mapa de Java
        JavaType type = mapper.getTypeFactory().constructMapType(HashMap.class, String.class, String.class);
        Map<String, String> requestBody = mapper.readValue(req.body(), type);

        // Obtener el usuario y la contraseña del cuerpo de la solicitud
        String usuario = requestBody.get("usuario");
        String contraseña = requestBody.get("contraseña");

        // Leer el mapa de usuarios desde el archivo JSON
        Map<String, String> usuarios = mapper.readValue(new File(RUTA_USUARIOS), type);

        // Verificar si el usuario existe y si la contraseña es correcta
        if (!usuarios.containsKey(usuario) || !usuarios.get(usuario).equals(contraseña)) {
            // Si las credenciales son incorrectas, devolver un mensaje de error y
            // establecer el código de estado 401 (Unauthorized)
            res.status(401);
            return "Credenciales incorrectas";
        }

        // Si las credenciales son correctas, establecer el código de estado 200 (OK)
        // para indicar un inicio de sesión exitoso
        res.status(200);
        return "Inicio de sesión exitoso";
    }
}

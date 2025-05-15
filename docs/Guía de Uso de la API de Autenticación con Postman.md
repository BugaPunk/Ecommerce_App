# Guía de Uso de la API de Autenticación con Postman

Esta documentación proporciona instrucciones detalladas sobre cómo utilizar la API de autenticación del proyecto e-commerce utilizando Postman.

## Índice

1. [Introducción](#introducción)
2. [Configuración de Postman](#configuración-de-postman)
3. [Endpoints de Autenticación](#endpoints-de-autenticación)
   - [Registro de Usuario](#registro-de-usuario)
   - [Inicio de Sesión](#inicio-de-sesión)
   - [Información de Sesión](#información-de-sesión)
   - [Cierre de Sesión](#cierre-de-sesión)
4. [Uso de JWT para Endpoints Protegidos](#uso-de-jwt-para-endpoints-protegidos)
5. [Ejemplos de Pruebas](#ejemplos-de-pruebas)

## Introducción

La API de autenticación del proyecto e-commerce utiliza JSON Web Tokens (JWT) para gestionar la autenticación y autorización de usuarios. Este sistema permite:

- Registro de nuevos usuarios
- Inicio de sesión con generación de tokens JWT
- Verificación de información de sesión
- Cierre de sesión
- Acceso a recursos protegidos según el rol del usuario

## Configuración de Postman

Para probar la API de autenticación, sigue estos pasos para configurar Postman:

1. **Descarga e instala Postman** desde [postman.com](https://www.postman.com/downloads/)
2. **Crea una nueva colección** para organizar tus peticiones:
   - Haz clic en "Collections" en el panel izquierdo
   - Haz clic en el botón "+" para crear una nueva colección
   - Nombra la colección "E-commerce API"

3. **Configura una variable de entorno** para almacenar la URL base y el token JWT:
   - Haz clic en el icono de engranaje (⚙️) en la esquina superior derecha
   - Selecciona "Manage Environments"
   - Haz clic en "Add" para crear un nuevo entorno
   - Nombra el entorno "E-commerce Local"
   - Añade las siguientes variables:
     - `base_url`: `http://localhost:8080`
     - `auth_token`: (déjalo vacío por ahora)
   - Guarda el entorno y selecciónalo en el desplegable de entornos

## Endpoints de Autenticación

### Registro de Usuario

Permite registrar un nuevo usuario en el sistema.

**Petición:**
- **Método:** POST
- **URL:** `{{base_url}}/api/auth/signup`
- **Headers:**
  - Content-Type: application/json
- **Body (JSON):**
  ```json
  {
    "username": "usuario_ejemplo",
    "email": "usuario@ejemplo.com",
    "password": "contraseña123",
    "firstName": "Nombre",
    "lastName": "Apellido",
    "roles": ["usuario"]
  }
  ```

**Notas:**
- El campo `roles` es opcional. Si no se proporciona, se asignará automáticamente el rol "ROLE_USUARIO".
- Los roles disponibles son:
  - **admin**: Rol de administrador con acceso completo a todas las funcionalidades del sistema.
  - **vendedor**: Rol de vendedor con permisos para gestionar productos, ver pedidos y atender clientes.
  - **usuario**: Rol básico para usuarios regulares que pueden comprar productos y gestionar su perfil.

**Ejemplos de registro con diferentes roles:**

1. **Registro como usuario regular:**
```json
{
  "username": "usuario_regular",
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "firstName": "Nombre",
  "lastName": "Apellido"
}
```

2. **Registro como vendedor:**
```json
{
  "username": "vendedor_ejemplo",
  "email": "vendedor@ejemplo.com",
  "password": "contraseña123",
  "firstName": "Nombre",
  "lastName": "Apellido",
  "roles": ["vendedor"]
}
```

3. **Registro como administrador:**
```json
{
  "username": "admin_ejemplo",
  "email": "admin@ejemplo.com",
  "password": "contraseña123",
  "firstName": "Nombre",
  "lastName": "Apellido",
  "roles": ["admin"]
}
```

4. **Registro con múltiples roles:**
```json
{
  "username": "multi_rol",
  "email": "multi@ejemplo.com",
  "password": "contraseña123",
  "firstName": "Nombre",
  "lastName": "Apellido",
  "roles": ["admin", "vendedor"]
}
```

**Respuesta exitosa (200 OK):**
```json
{
  "message": "User registered successfully!"
}
```

**Posibles errores:**
- **400 Bad Request:** Si el nombre de usuario o email ya están en uso
  ```json
  {
    "message": "Error: Username is already taken!"
  }
  ```
  o
  ```json
  {
    "message": "Error: Email is already in use!"
  }
  ```

### Inicio de Sesión

Permite a un usuario iniciar sesión y obtener un token JWT.

**Petición:**
- **Método:** POST
- **URL:** `{{base_url}}/api/auth/login`
- **Headers:**
  - Content-Type: application/json
- **Body (JSON):**
  ```json
  {
    "username": "usuario_ejemplo",
    "password": "contraseña123"
  }
  ```

**Respuesta exitosa (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "usuario_ejemplo",
  "email": "usuario@ejemplo.com",
  "roles": ["ROLE_USUARIO"]
}
```

**Importante:** Después de recibir el token JWT, configúralo como variable de entorno en Postman:
1. En la pestaña "Tests" de la petición de login, añade este código:
   ```javascript
   var jsonData = pm.response.json();
   pm.environment.set("auth_token", jsonData.token);
   ```
2. Esto guardará automáticamente el token en la variable `auth_token` para usarlo en futuras peticiones.

**Posibles errores:**
- **401 Unauthorized:** Si las credenciales son incorrectas

### Información de Sesión

Permite obtener información sobre la sesión actual del usuario.

**Petición:**
- **Método:** GET
- **URL:** `{{base_url}}/api/auth/session-info`
- **Headers:**
  - Authorization: Bearer {{auth_token}}

**Respuesta exitosa (200 OK):**
```json
{
  "token": null,
  "type": "Bearer",
  "id": 1,
  "username": "usuario_ejemplo",
  "email": "usuario@ejemplo.com",
  "roles": ["ROLE_USUARIO"]
}
```

**Posibles errores:**
- **401 Unauthorized:** Si el token no es válido o ha expirado

### Cierre de Sesión

Permite cerrar la sesión actual del usuario.

**Petición:**
- **Método:** POST
- **URL:** `{{base_url}}/api/auth/logout`
- **Headers:**
  - Authorization: Bearer {{auth_token}}

**Respuesta exitosa (200 OK):**
```json
{
  "message": "Logged out successfully!"
}
```

## Sistema de Roles y Permisos

El sistema de e-commerce implementa un control de acceso basado en roles (RBAC) que determina qué acciones puede realizar cada usuario según su rol asignado.

### Roles Disponibles

1. **ROLE_USUARIO**
   - Rol predeterminado asignado a nuevos usuarios si no se especifica otro
   - Permisos:
     - Ver catálogo de productos
     - Realizar compras
     - Gestionar su propio perfil y pedidos
     - Escribir reseñas de productos

2. **ROLE_VENDEDOR**
   - Rol para vendedores y personal de tienda
   - Permisos:
     - Todos los permisos de ROLE_USUARIO
     - Gestionar inventario de productos
     - Ver y procesar pedidos
     - Acceder a estadísticas básicas de ventas
     - Responder a reseñas de clientes

3. **ROLE_ADMIN**
   - Rol con máximos privilegios para administradores del sistema
   - Permisos:
     - Acceso completo a todas las funcionalidades
     - Gestión de usuarios y asignación de roles
     - Configuración del sistema
     - Acceso a reportes y estadísticas avanzadas
     - Gestión de tiendas y vendedores

### Endpoints según Rol

| Endpoint | ROLE_USUARIO | ROLE_VENDEDOR | ROLE_ADMIN |
|----------|--------------|---------------|------------|
| `/api/productos/**` | ✅ (lectura) | ✅ (lectura/escritura) | ✅ (lectura/escritura) |
| `/api/pedidos/**` | ✅ (solo propios) | ✅ (todos) | ✅ (todos) |
| `/api/usuarios/**` | ❌ | ❌ | ✅ |
| `/api/admin/**` | ❌ | ❌ | ✅ |
| `/api/ventas/**` | ❌ | ✅ (limitado) | ✅ (completo) |

## Uso de JWT para Endpoints Protegidos

Para acceder a endpoints protegidos, debes incluir el token JWT en el encabezado de autorización:

1. En Postman, añade un nuevo encabezado a tu petición:
   - Key: Authorization
   - Value: Bearer {{auth_token}}

2. Esto permitirá que el servidor autentique tu petición y verifique los permisos según el rol del usuario.

### Ejemplo de Endpoint Protegido

**Petición:**
- **Método:** GET
- **URL:** `{{base_url}}/api/test`
- **Headers:**
  - Authorization: Bearer {{auth_token}}

## Ejemplos de Pruebas

### Flujo completo de autenticación

1. **Registrar un nuevo usuario**:
   - Realiza una petición POST a `/api/auth/signup` con los datos del usuario
   - Verifica que la respuesta sea "User registered successfully!"

2. **Iniciar sesión**:
   - Realiza una petición POST a `/api/auth/login` con las credenciales
   - Verifica que recibas un token JWT
   - El token se guardará automáticamente en la variable de entorno `auth_token`

3. **Verificar información de sesión**:
   - Realiza una petición GET a `/api/auth/session-info` incluyendo el token JWT
   - Verifica que la información del usuario sea correcta

4. **Acceder a un endpoint protegido**:
   - Realiza una petición a un endpoint protegido incluyendo el token JWT
   - Verifica que puedas acceder según tu rol

5. **Cerrar sesión**:
   - Realiza una petición POST a `/api/auth/logout` incluyendo el token JWT
   - Verifica que la sesión se cierre correctamente

### Ejemplos de pruebas por rol

#### Pruebas para ROLE_USUARIO

1. **Registro de usuario regular** (POST `/api/auth/signup`):
   ```json
   {
     "username": "cliente1",
     "email": "cliente1@ejemplo.com",
     "password": "contraseña123",
     "firstName": "Cliente",
     "lastName": "Uno"
   }
   ```

2. **Iniciar sesión como usuario** (POST `/api/auth/login`):
   ```json
   {
     "username": "cliente1",
     "password": "contraseña123"
   }
   ```

3. **Acceder a endpoints permitidos para usuarios**:
   - `GET /api/productos` - Ver catálogo de productos (permitido)
   - `GET /api/pedidos/propios` - Ver pedidos propios (permitido)
   - `GET /api/admin/usuarios` - Ver lista de usuarios (denegado)

#### Pruebas para ROLE_VENDEDOR

1. **Registro de vendedor** (POST `/api/auth/signup`):
   ```json
   {
     "username": "vendedor1",
     "email": "vendedor1@ejemplo.com",
     "password": "contraseña123",
     "firstName": "Vendedor",
     "lastName": "Uno",
     "roles": ["vendedor"]
   }
   ```

2. **Iniciar sesión como vendedor** (POST `/api/auth/login`):
   ```json
   {
     "username": "vendedor1",
     "password": "contraseña123"
   }
   ```

3. **Acceder a endpoints permitidos para vendedores**:
   - `GET /api/productos` - Ver catálogo de productos (permitido)
   - `POST /api/productos` - Crear nuevo producto (permitido)
   - `GET /api/pedidos` - Ver todos los pedidos (permitido)
   - `GET /api/admin/usuarios` - Ver lista de usuarios (denegado)

#### Pruebas para ROLE_ADMIN

1. **Registro de administrador** (POST `/api/auth/signup`):
   ```json
   {
     "username": "admin1",
     "email": "admin1@ejemplo.com",
     "password": "contraseña123",
     "firstName": "Admin",
     "lastName": "Uno",
     "roles": ["admin"]
   }
   ```

2. **Iniciar sesión como administrador** (POST `/api/auth/login`):
   ```json
   {
     "username": "admin1",
     "password": "contraseña123"
   }
   ```

3. **Acceder a endpoints permitidos para administradores**:
   - `GET /api/productos` - Ver catálogo de productos (permitido)
   - `POST /api/productos` - Crear nuevo producto (permitido)
   - `GET /api/pedidos` - Ver todos los pedidos (permitido)
   - `GET /api/admin/usuarios` - Ver lista de usuarios (permitido)
   - `POST /api/admin/roles` - Asignar roles a usuarios (permitido)

### Consejos para pruebas

- **Prueba diferentes roles**: Registra usuarios con diferentes roles y verifica que solo puedan acceder a los endpoints permitidos para su rol.
- **Prueba la expiración del token**: Los tokens JWT expiran después de 24 horas (configurable en `application.properties`). Puedes probar este comportamiento modificando la fecha de expiración.
- **Prueba errores comunes**: Intenta acceder a endpoints protegidos sin token o con un token inválido para verificar el manejo de errores.
- **Prueba la escalabilidad de roles**: Crea un usuario con múltiples roles y verifica que tenga acceso a todos los endpoints correspondientes a esos roles.

---

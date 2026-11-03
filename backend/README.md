# TRANSIGOVAI - Backend API (MTC Marcona)

API REST robusta desarrollada con **Spring Boot 3** y **Java 21** para el sistema de Gestión de Transporte Urbano, Vehículos, Conductores, Empresas y Tarjetas Únicas de Circulación (TUC) de la Municipalidad Distrital de Marcona.

---

## 🛠️ Tecnologías y Arquitectura

- **Lenguaje:** Java 21 (LTS)
- **Framework:** Spring Boot 3.5.3
- **Base de Datos:** MySQL 8.0
- **Seguridad:** Autenticación y Autorización basada en **JWT (JSON Web Token)** y BCrypt
- **Documentación Interactiva:** OpenAPI 3 / Swagger UI (`springdoc-openapi`)
- **Monitoreo:** Spring Boot Actuator (`/actuator/health`, `/actuator/metrics`)
- **Automatización:** Tareas programadas con Spring Scheduling (`@EnableScheduling`)
- **Arquitectura:** En capas (**Controller - Service - DAO/Model**) con diseño desacoplado **Cliente - Servidor**

---

## 🚀 Requisitos Previos

1. **Java JDK 21** o superior instalado y configurado en el PATH.
2. **Apache Maven 3.9+** (o usar el comando `mvn`).
3. **MySQL 8.0** en ejecución (puerto `3306`), ya sea mediante Docker o localmente.

---

## ⚙️ Configuración (`application.properties`)

El backend viene preconfigurado para conectarse a MySQL:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/marcona_permisos?useUnicode=true&characterEncoding=utf8&serverTimezone=America/Lima
spring.datasource.username=root
spring.datasource.password=
```

Puedes sobrescribir cualquier propiedad mediante variables de entorno:
- `PORT` (por defecto: `8080`)
- `DB_HOST` (por defecto: `localhost`)
- `DB_PORT` (por defecto: `3306`)
- `DB_NAME` (por defecto: `marcona_permisos`)
- `DB_USER` (por defecto: `root`)
- `DB_PASS` (por defecto: vacío)

---

## 📦 Ejecución del Proyecto

### 1. Compilar y ejecutar pruebas unitarias:
```bash
mvn clean test
```

### 2. Iniciar el servidor en modo desarrollo:
```bash
mvn spring-boot:run
```
El servidor iniciará en: `http://localhost:8080`

---

## 📖 Documentación de la API (Swagger UI)

Una vez iniciado el servidor, accede a la documentación interactiva:
- **Swagger UI:** [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **OpenAPI JSON:** [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)

> **Nota:** Para probar endpoints protegidos en Swagger UI, utiliza el botón verde **"Authorize"** e ingresa el token JWT generado en el login.

---

## 🩺 Monitoreo y Salud del Sistema
- **Health Check:** `http://localhost:8080/actuator/health`
- **Métricas:** `http://localhost:8080/actuator/metrics`

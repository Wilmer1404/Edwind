# TRANSIGOVAI - Frontend Web Application (MTC Marcona)

Interfaz web moderna, responsiva y de alto rendimiento desarrollada con **React**, **TypeScript**, **Vite** y **Tailwind CSS** para el Sistema de Gestión de Transporte Urbano, Vehículos, Conductores, Empresas y Tarjetas Únicas de Circulación (TUC) de la Municipalidad Distrital de Marcona.

---

## 🛠️ Tecnologías Utilizadas

- **Framework:** React 18 + Vite
- **Lenguaje:** TypeScript
- **Estilos:** Tailwind CSS + Radix UI + Lucide React Icons
- **Peticiones HTTP:** Fetch API / Axios con interceptores de tokens JWT
- **Enrutamiento:** React Router DOM (vistas públicas y rutas protegidas por roles)
- **Generación y Lectura QR:** ZXing / QRCode para credenciales y verificación ciudadana
- **Exportación:** Exportación de tablas y padrones vehiculares a Excel

---

## 🚀 Requisitos Previos

- **Node.js:** Versión 18.x o 20.x LTS recomendada.
- **npm:** Versión 9.x o superior.
- **Backend TRANSIGOVAI:** API REST en Spring Boot en ejecución en `http://localhost:8080`.

---

## ⚙️ Configuración de Variables de Entorno (`.env`)

Crea un archivo `.env` en la raíz del frontend (o copia `.env.example`):

```properties
VITE_API_URL=http://localhost:8080
VITE_APP_NAME="TRANSIGOVAI - MTC Marcona"
```

---

## 📦 Instalación y Ejecución

### 1. Instalar dependencias del proyecto:
```bash
npm install
```

### 2. Iniciar el servidor de desarrollo local:
```bash
npm run dev
```
La aplicación estará disponible de inmediato en: `http://localhost:5173`

### 3. Compilar para producción:
```bash
npm run build
```

---

## 👥 Módulos y Perfiles de Acceso

1. **Portal Ciudadano / Fiscalización Móvil:**
   - Consulta pública de TUC por código QR o número de placa vehicular.
   - Verificación de vigencia de autorizaciones y datos del conductor.
2. **Panel Administrativo (MTC Marcona):**
   - **Padrón Vehicular:** Registro, edición, bajas y consulta técnica de unidades.
   - **Conductores y Empresas:** Administración de licencias de conducir y empresas concesionarias.
   - **Permisos y TUC:** Emisión de resoluciones, generación de credenciales TUC y prórrogas.
   - **Bitácora de Auditoría:** Trazabilidad completa de acciones y operaciones de usuario.

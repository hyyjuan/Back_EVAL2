# Innovatech Chile — Backend

API REST para el sistema de gestión de usuarios de Innovatech Chile.
Desplegado en AWS EC2 con Docker y CI/CD automatizado via GitHub Actions.

## Stack tecnológico

- **Runtime:** Node.js 18
- **Framework:** Express 4.18
- **Base de datos:** MySQL 8.0
- **Contenedor:** Docker (multi-stage build)
- **CI/CD:** GitHub Actions + Docker Hub
- **Infraestructura:** AWS EC2 en VPC

## Estructura del repositorio

```
.
├── server.js              # Punto de entrada — API REST
├── package.json           # Dependencias Node.js
├── package-lock.json      # Versiones exactas de dependencias
├── Dockerfile             # Multi-stage build (builder + runner)
├── docker-compose.yml     # Stack completo: backend + MySQL
├── initdb/
│   └── 01_creacion_base_datos.sql  # Inicialización automática de MySQL
├── .env.example           # Variables de entorno de referencia
├── .gitignore             # Excluye .env y llaves
└── .github/
    └── workflows/
        └── deploy.yml     # Pipeline CI/CD
```

## Cómo ejecutar localmente

```bash
git clone https://github.com/hyyjuan/Back_EVAL2
cd Back_EVAL2
cp .env.example .env
# Editar .env con tus valores
docker compose up -d
docker compose ps
curl http://localhost:3000
```

## Endpoints disponibles

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | / | Health check de la API |
| GET | /api/usuarios | Listar todos los usuarios |
| POST | /api/usuarios | Crear nuevo usuario |
| PUT | /api/usuarios/:id | Actualizar usuario |
| DELETE | /api/usuarios/:id | Eliminar usuario |

## Pipeline CI/CD

El pipeline se activa automáticamente al hacer push a la rama `deploy`.

**Flujo:** push a deploy → build imagen Docker → push a Docker Hub → deploy en EC2 vía SSH

## Variables de entorno

| Variable | Descripción | Default |
|----------|-------------|---------|
| PORT | Puerto del servidor | 3000 |
| DB_HOST | Host de MySQL | db |
| DB_USER | Usuario MySQL | root |
| DB_PASSWORD | Contraseña MySQL | — |
| DB_NAME | Nombre de la BD | proyecto_db |
| DB_PORT | Puerto MySQL | 3306 |

## GitHub Secrets requeridos

- `DOCKERHUB_USERNAME` — usuario de Docker Hub
- `DOCKERHUB_TOKEN` — token de acceso Docker Hub
- `EC2_HOST` — IP pública de ec2-back
- `EC2_USER` — ec2-user
- `EC2_SSH_KEY` — contenido del archivo .pem

## Decisiones técnicas

**Multi-stage build:** separa el entorno de construcción del de ejecución, generando imágenes más livianas y seguras sin herramientas de desarrollo innecesarias.

**Usuario no root:** el contenedor corre con un usuario sin privilegios aplicando el principio de mínimo privilegio.

**Named volume:** se eligió named volume sobre bind mount porque Docker gestiona el almacenamiento automáticamente, es más portable y no expone rutas del sistema host al contenedor.

**Docker Hub sobre ECR:** AWS Academy genera credenciales temporales que rotan cada pocas horas, lo que hace inviable ECR en pipelines automáticos. Docker Hub usa credenciales permanentes almacenadas como GitHub Secrets.

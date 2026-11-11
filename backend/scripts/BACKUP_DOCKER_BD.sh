#!/usr/bin/env bash
set -euo pipefail

# Script de respaldo para entornos Docker (Linux / macOS)
# Genera un dump SQL de la base de datos marcona_permisos desde el contenedor transigovai-db

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
BACKUP_DIR="${PROJECT_ROOT}/backups"

mkdir -p "${BACKUP_DIR}"

CONTAINER_NAME="transigovai-db"
DB_NAME="marcona_permisos"
TIMESTAMP="$(date +%Y%m%d_%H%M)"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

echo "======================================================================"
echo "  RESPALDO AUTOMATIZADO DE BASE DE DATOS (DOCKER / MySQL)"
echo "  Plataforma TUC - Municipalidad Distrital de Marcona"
echo "======================================================================"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[ERROR] El contenedor ${CONTAINER_NAME} no se encuentra en ejecucion."
    echo "Levantalo ejecutando: docker compose -f infraestructura/docker-compose.yml up -d"
    exit 1
fi

echo "[*] Exportando base de datos '${DB_NAME}' desde ${CONTAINER_NAME}..."
docker exec "${CONTAINER_NAME}" mysqldump -u root --opt --routines --triggers --default-character-set=utf8mb4 "${DB_NAME}" > "${BACKUP_FILE}"

FILE_SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)

echo "======================================================================"
echo "  [EXITO] Respaldo generado correctamente"
echo "  Archivo: ${BACKUP_FILE}"
echo "  Tamano : ${FILE_SIZE}"
echo "  Fecha  : $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================================================================"

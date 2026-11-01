@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ======================================================================
echo   RESPALDO AUTOMATIZADO DE BASE DE DATOS (XAMPP / MySQL)
echo   Plataforma TUC - Municipalidad Distrital de Marcona
echo ======================================================================
echo.

:: 1. Definicion de rutas y parametros
set "DB_NAME=marcona_permisos"
set "DB_USER=root"
if "%DB_PASS%"=="" (
    set "AUTH_PARAM=-u %DB_USER%"
) else (
    set "AUTH_PARAM=-u %DB_USER% -p%DB_PASS%"
)

:: Carpeta de backups en la raiz del proyecto
set "PROJECT_ROOT=%~dp0..\.."
set "BACKUP_DIR=%PROJECT_ROOT%\backups"

if not exist "%BACKUP_DIR%" (
    echo [*] Creando directorio de respaldos en: "%BACKUP_DIR%"
    mkdir "%BACKUP_DIR%"
)

:: 2. Deteccion de mysqldump.exe (XAMPP o PATH del sistema)
set "MYSQLDUMP_EXE=C:\xampp\mysql\bin\mysqldump.exe"
set "MYSQL_EXE=C:\xampp\mysql\bin\mysql.exe"

if not exist "%MYSQLDUMP_EXE%" (
    echo [!] No se encontro mysqldump en C:\xampp\mysql\bin\mysqldump.exe.
    echo [*] Buscando en variables de entorno del sistema (PATH)...
    where mysqldump >nul 2>nul
    if %errorlevel% equ 0 (
        for /f "delims=" %%I in ('where mysqldump') do (
            set "MYSQLDUMP_EXE=%%I"
            goto :found_dump
        )
    )
    if exist "D:\xampp\mysql\bin\mysqldump.exe" (
        set "MYSQLDUMP_EXE=D:\xampp\mysql\bin\mysqldump.exe"
        set "MYSQL_EXE=D:\xampp\mysql\bin\mysql.exe"
        goto :found_dump
    )

    echo.
    echo [ERROR] No se encontro la utilidad mysqldump.exe.
    echo Verifica que XAMPP este instalado en C:\xampp o que MySQL este en tu PATH.
    echo.
    pause
    exit /b 1
)

:found_dump
echo [OK] Binario mysqldump detectado: "%MYSQLDUMP_EXE%"
echo.

:: 3. Generacion de marca de tiempo (Timestamp formato YYYYMMDD_HHMM)
set "TIMESTAMP="
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmm" 2^>nul') do (
    set "TIMESTAMP=%%a"
)

if "%TIMESTAMP%"=="" (
    :: Fallback por variables nativas de fecha y hora
    set "FECHA=%date%"
    set "HORA=%time%"
    set "TIMESTAMP=%FECHA:~6,4%%FECHA:~3,2%%FECHA:~0,2%_%HORA:~0,2%%HORA:~3,2%"
    set "TIMESTAMP=!TIMESTAMP: =0!"
    set "TIMESTAMP=!TIMESTAMP:/=!"
    set "TIMESTAMP=!TIMESTAMP:-=!"
)

set "BACKUP_FILE=%BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql"

:: 4. Ejecucion del volcado de base de datos
echo [*] Conectando con MySQL en localhost:3306...
echo [*] Base de datos objetivo: %DB_NAME%
echo [*] Generando archivo de respaldo: "%DB_NAME%_%TIMESTAMP%.sql" ...
echo.

"%MYSQLDUMP_EXE%" %AUTH_PARAM% --opt --routines --triggers --default-character-set=utf8mb4 --result-file="%BACKUP_FILE%" %DB_NAME%

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Fallo al generar el respaldo de la base de datos %DB_NAME%.
    echo Asegurate de que el servicio MySQL de XAMPP este encendido (Status: Running).
    echo.
    if exist "%BACKUP_FILE%" del "%BACKUP_FILE%" >nul 2>nul
    pause
    exit /b 1
)

:: 5. Validacion del archivo de salida
if not exist "%BACKUP_FILE%" (
    echo [ERROR] El archivo de respaldo no fue creado.
    pause
    exit /b 1
)

for %%A in ("%BACKUP_FILE%") do set "TAMANIO=%%~zA"
if %TAMANIO% equ 0 (
    echo [ERROR] El archivo generado tiene 0 bytes (vacio).
    del "%BACKUP_FILE%" >nul 2>nul
    pause
    exit /b 1
)

echo.
echo ======================================================================
echo   [EXITO] RESPALDO DE BASE DE DATOS COMPLETADO SATISFACTORIAMENTE
echo ======================================================================
echo   Archivo: %BACKUP_FILE%
echo   Tamano : %TAMANIO% bytes
echo   Fecha  : %DATE% - %TIME%
echo ======================================================================
echo.
pause

@echo off
setlocal enabledelayedexpansion
cls

echo ==========================================
echo    Avviatore Docker per Gemini Env
echo ==========================================
echo.

:: Definizione del path di default per l'output
set "DEFAULT_OUT_PATH=INSERISCI\IL\DEFAULT\PATH\OUTPUT\GEMINI"

:INPUT_PROJECT
echo --- STEP 1: Progetto ---
set /p PROJECT_PATH="Inserisci il path del progetto (es. D:\Cartella\Progetto): "
if "%PROJECT_PATH%"=="" (
    echo Il path del progetto non puo essere vuoto.
    goto INPUT_PROJECT
)

:: Estrazione del nome della cartella (Nome Progetto)
for %%I in ("%PROJECT_PATH%") do set "PROJECT_NAME=%%~nxI"

:INPUT_OUTPUT
echo.
echo --- STEP 2: Output ---
echo Premi INVIO per usare il path di default: %DEFAULT_OUT_PATH%
set "USER_OUT_PATH="
set /p USER_OUT_PATH="Oppure inserisci un nuovo path di output: "

if "%USER_OUT_PATH%"=="" (
    set "FINAL_OUT_PATH=%DEFAULT_OUT_PATH%"
) else (
    set "FINAL_OUT_PATH=%USER_OUT_PATH%"
)

:CONFIRM
echo.
echo ==========================================
echo RIEPILOGO CONFIGURAZIONE:
echo 1. Progetto: "%PROJECT_NAME%" (%PROJECT_PATH%)
echo 2. Output:   "%FINAL_OUT_PATH%"
echo ==========================================
set /p USER_CONFIRM="I dati sono corretti? (Y/N): "

if /i "%USER_CONFIRM%"=="n" goto INPUT_PROJECT
if /i not "%USER_CONFIRM%"=="y" goto CONFIRM

:ASK_SHORTCUT
echo.
set /p CREATE_SCR="Vuoi creare un file di avvio rapido per questo progetto? (Y/N): "
if /i "%CREATE_SCR%"=="n" goto RUN_DOCKER
if /i not "%CREATE_SCR%"=="y" goto ASK_SHORTCUT

:SHORTCUT_LOCATION
set "SHORTCUT_FILENAME=run_gemini_%PROJECT_NAME%.bat"
echo.
echo Dove vuoi salvare "%SHORTCUT_FILENAME%"?
echo Premi INVIO per salvarlo nella cartella output: %FINAL_OUT_PATH%

:: Svuoto la variabile per sicurezza
set "SCR_DIR="
set /p SCR_DIR="Percorso: "

:: FIX: Imposto il default. Se l'utente ha scritto un path, lo sovrascrivo. Zero parentesi!
set "FINAL_SCR_PATH=%FINAL_OUT_PATH%\%SHORTCUT_FILENAME%"
if not "%SCR_DIR%"=="" set "FINAL_SCR_PATH=%SCR_DIR%\%SHORTCUT_FILENAME%"

:: Creazione del file di avvio rapido
echo @echo off > "%FINAL_SCR_PATH%"
echo echo Avvio rapido per il progetto: %PROJECT_NAME% >> "%FINAL_SCR_PATH%"
echo docker run -it --rm ^
 -v "%PROJECT_PATH%:/mnt/host_context" ^
 -v "gemini-config-data:/root/.config" ^
 -v "gemini-auth-data:/root/.gemini" ^
 -v "%FINAL_OUT_PATH%:/app/output" ^
 gemini-env >> "%FINAL_SCR_PATH%"
echo pause >> "%FINAL_SCR_PATH%"

echo.
echo [+] File di avvio rapido creato con successo in:
echo     "%FINAL_SCR_PATH%"

:RUN_DOCKER
echo.
echo Avvio del container Docker...
echo.

docker run -it --rm ^
 -v "%PROJECT_PATH%:/mnt/host_context" ^
 -v "gemini-config-data:/root/.config" ^
 -v "gemini-auth-data:/root/.gemini" ^
 -v "%FINAL_OUT_PATH%:/app/output" ^
 gemini-env

echo.
echo Container terminato.
pause
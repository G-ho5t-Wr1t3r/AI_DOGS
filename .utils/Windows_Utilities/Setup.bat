@echo off
setlocal enabledelayedexpansion
cls

echo ==========================================
echo    Initial container setup (Claude / Gemini)
echo ==========================================
echo.
echo Run this ONCE per environment: it builds the image,
echo creates the persistent volumes and starts the container for login.
echo.

set "SCRIPT_DIR=%~dp0"

:CHOOSE_ENGINE
echo --- Which environment do you want to configure? ---
echo   [C] Claude
echo   [G] Gemini
set "ENGINE_CHOICE="
set /p ENGINE_CHOICE="Choice (C/G): "
if /i "%ENGINE_CHOICE%"=="c" goto SET_CLAUDE
if /i "%ENGINE_CHOICE%"=="g" goto SET_GEMINI
echo Invalid choice.
echo.
goto CHOOSE_ENGINE

:SET_CLAUDE
set "ENGINE=Claude"
set "IMAGE=claude-env"
set "AUTH_VOL=claude-auth-data"
set "CONFIG_VOL=claude-config-data"
set "AUTH_DIR=/home/node/.claude"
set "CONFIG_DIR=/home/node/.config"
set "BUILD_DIR=%SCRIPT_DIR%..\..\Claude"
goto ENGINE_DONE

:SET_GEMINI
set "ENGINE=Gemini"
set "IMAGE=gemini-env"
set "AUTH_VOL=gemini-auth-data"
set "CONFIG_VOL=gemini-config-data"
set "AUTH_DIR=/root/.gemini"
set "CONFIG_DIR=/root/.config"
set "BUILD_DIR=%SCRIPT_DIR%..\..\Gemini"
goto ENGINE_DONE

:ENGINE_DONE
echo.
echo Selected environment: %ENGINE%
echo Build folder:         "%BUILD_DIR%"
echo.

if not exist "%BUILD_DIR%\Dockerfile" (
    echo ERROR: Dockerfile not found in "%BUILD_DIR%".
    echo Make sure this script lives in .utils\Windows_Utilities\
    pause
    exit /b 1
)

echo [1/3] Building image "%IMAGE%"...
pushd "%BUILD_DIR%"
docker build -t "%IMAGE%" .
if errorlevel 1 (
    echo ERROR during build.
    popd
    pause
    exit /b 1
)
popd

echo.
echo [2/3] Creating persistent volumes...
docker volume create %AUTH_VOL%
docker volume create %CONFIG_VOL%

echo.
echo [3/3] Starting container for login.
echo Inside the container, log in. For Claude run: claude
echo When you are done type 'exit': credentials stay saved in the volume.
echo.

docker run -it --rm ^
 -v "%AUTH_VOL%:%AUTH_DIR%" ^
 -v "%CONFIG_VOL%:%CONFIG_DIR%" ^
 %IMAGE%

echo.
echo Setup completed for %ENGINE%.
echo You can now use the Launcher to start individual projects.
pause
@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo    Remove containers (Claude / Gemini)
echo ==========================================
echo.

:CHOOSE_ENGINE
echo   [C] Claude
echo   [G] Gemini
set "ENGINE_CHOICE="
set /p ENGINE_CHOICE="Which environment do you want to remove? (C/G): "
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
goto ENGINE_DONE

:SET_GEMINI
set "ENGINE=Gemini"
set "IMAGE=gemini-env"
set "AUTH_VOL=gemini-auth-data"
set "CONFIG_VOL=gemini-config-data"
goto ENGINE_DONE

:ENGINE_DONE
echo.
echo You are about to remove the image and volumes for: %ENGINE%
set /p CONFIRM="Confirm? (Y/N): "
if /i not "%CONFIRM%"=="y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
echo 1. Removing associated containers...
FOR /f "tokens=*" %%i IN ('docker ps -a -q --filter "ancestor=%IMAGE%"') DO docker rm -f %%i

echo.
echo 2. Removing Image...
docker rmi %IMAGE%

echo.
echo 3. Removing Volumes...
docker volume rm %AUTH_VOL%
docker volume rm %CONFIG_VOL%

echo.
echo Done.
pause
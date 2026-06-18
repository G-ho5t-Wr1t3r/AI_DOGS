@echo off
setlocal enabledelayedexpansion
cls

echo ==========================================
echo    Docker Launcher (Claude / Gemini)
echo ==========================================
echo.

:CHOOSE_ENGINE
echo --- STEP 0: Environment ---
echo   [C] Claude
echo   [G] Gemini
set "ENGINE_CHOICE="
set /p ENGINE_CHOICE="Which container do you want to start? (C/G): "
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
for %%I in ("%~dp0..\..\Claude\claude_output") do set "DEFAULT_OUT_PATH=%%~fI"
goto ENGINE_DONE

:SET_GEMINI
set "ENGINE=Gemini"
set "IMAGE=gemini-env"
set "AUTH_VOL=gemini-auth-data"
set "CONFIG_VOL=gemini-config-data"
set "AUTH_DIR=/root/.gemini"
for %%I in ("%~dp0..\..\Gemini\gemini_output") do set "DEFAULT_OUT_PATH=%%~fI"
goto ENGINE_DONE

:ENGINE_DONE
echo.
echo Environment: %ENGINE%

:INPUT_PROJECT
echo.
echo --- STEP 1: Project ---
set /p PROJECT_PATH="Enter the project path (e.g. D:\Folder\Project): "
set "PROJECT_PATH=!PROJECT_PATH:"=!"
if "%PROJECT_PATH%"=="" (
    echo The project path cannot be empty.
    goto INPUT_PROJECT
)

for %%I in ("%PROJECT_PATH%") do set "PROJECT_NAME=%%~nxI"

:INPUT_OUTPUT
echo.
echo --- STEP 2: Output ---
echo Press ENTER to use the default path: %DEFAULT_OUT_PATH%
set "USER_OUT_PATH="
set /p USER_OUT_PATH="Or enter a new output path: "
set "USER_OUT_PATH=!USER_OUT_PATH:"=!"

if "%USER_OUT_PATH%"=="" (
    set "FINAL_OUT_PATH=%DEFAULT_OUT_PATH%"
) else (
    set "FINAL_OUT_PATH=%USER_OUT_PATH%"
)

:CONFIRM
echo.
echo ==========================================
echo CONFIGURATION SUMMARY:
echo Environment: %ENGINE%
echo 1. Project:  "%PROJECT_NAME%" (%PROJECT_PATH%)
echo 2. Output:   "%FINAL_OUT_PATH%"
echo ==========================================
set /p USER_CONFIRM="Is the data correct? (Y/N): "

if /i "%USER_CONFIRM%"=="n" goto INPUT_PROJECT
if /i not "%USER_CONFIRM%"=="y" goto CONFIRM

:ASK_SHORTCUT
echo.
set /p CREATE_SCR="Do you want to create a quick-launch file for this project? (Y/N): "
if /i "%CREATE_SCR%"=="n" goto RUN_DOCKER
if /i not "%CREATE_SCR%"=="y" goto ASK_SHORTCUT

:SHORTCUT_LOCATION
set "SHORTCUT_FILENAME=run_%ENGINE%_%PROJECT_NAME%.bat"
echo.
echo Where do you want to save "%SHORTCUT_FILENAME%"?
echo Press ENTER to save it in the output folder: %FINAL_OUT_PATH%

set "SCR_DIR="
set /p SCR_DIR="Path: "

set "FINAL_SCR_PATH=%FINAL_OUT_PATH%\%SHORTCUT_FILENAME%"
if not "%SCR_DIR%"=="" set "FINAL_SCR_PATH=%SCR_DIR%\%SHORTCUT_FILENAME%"

echo @echo off > "%FINAL_SCR_PATH%"
echo echo Quick launch [%ENGINE%] - project: %PROJECT_NAME% >> "%FINAL_SCR_PATH%"
echo docker run -it --rm ^
 -v "%PROJECT_PATH%:/mnt/host_context" ^
 -v "%CONFIG_VOL%:/root/.config" ^
 -v "%AUTH_VOL%:%AUTH_DIR%" ^
 -v "%FINAL_OUT_PATH%:/app/output" ^
 %IMAGE% >> "%FINAL_SCR_PATH%"
echo pause >> "%FINAL_SCR_PATH%"

echo.
echo [+] Quick-launch file created successfully at:
echo     "%FINAL_SCR_PATH%"

:RUN_DOCKER
echo.
echo Starting the %ENGINE% container...
echo.

docker run -it --rm ^
 -v "%PROJECT_PATH%:/mnt/host_context" ^
 -v "%CONFIG_VOL%:/root/.config" ^
 -v "%AUTH_VOL%:%AUTH_DIR%" ^
 -v "%FINAL_OUT_PATH%:/app/output" ^
 %IMAGE%

echo.
echo Container stopped.
pause
@echo off

echo 1. Removing associated containers...
FOR /f "tokens=*" %%i IN ('docker ps -a -q --filter "ancestor=gemini-env"') DO docker rm -f %%i

echo.
echo 2. Removing Image...
docker rmi gemini-env

echo.
echo 3. Removing Volumes...
docker volume rm gemini-auth-data

echo.
echo 4. Cleaning System...
docker system prune -f

echo.
pause
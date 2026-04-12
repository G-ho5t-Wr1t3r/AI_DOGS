echo "Removing Image..."
docker rmi gemini-env

echo "Removing Volumes..."
docker volume rm gemini-auth-data

echo "Cleaning System..."
docker system prune -f

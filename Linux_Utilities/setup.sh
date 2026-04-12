echo "Building Image..."
# Build docker image locally
docker build -t gemini-env .

echo "Creating auth volume..."
# Create persistent data volume
docker volume create gemini-auth-data

echo "Starting container..."
# Run container with volumes
docker run -it --rm \
-v ~/Desktop/CCIT:/mnt/host_context \
-v gemini-auth-data:/root \
-v ~/Desktop/Coding/Gemini/gemini_output:/app/output \
gemini-env

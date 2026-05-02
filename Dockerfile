# Base debian image
FROM node:20-bookworm

# Set terminal colors
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    tree \
    nano \
    git \
    || (echo "Apt failed" && exit 1)

# Install Gemini CLI
RUN npm install -g @google/gemini-cli || (echo "NPM failed" && exit 1)

# Install superpowers extension
RUN yes | gemini extensions install https://github.com/obra/superpowers || (echo "Extension failed" && exit 1)

# Set working directory
WORKDIR /app

# Create required directories
RUN mkdir -p /app/context /mnt/host_context /root/.gemini /root/.config || (echo "Mkdir failed" && exit 1)

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make entrypoint executable
RUN chmod +x /usr/local/bin/entrypoint.sh || (echo "Chmod failed" && exit 1)

# Set container entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
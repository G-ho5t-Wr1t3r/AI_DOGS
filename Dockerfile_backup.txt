# Use full debian image
FROM node:20-bookworm

# Force true color terminal
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Install basic required tools
RUN apt-get update && apt-get install -y \
    curl \
    tree \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install official Gemini CLI
RUN npm install -g @google/gemini-cli

# Setup application working directory
WORKDIR /app

# Create necessary internal directories
RUN mkdir -p /app/context /mnt/host_context /root/.gemini /root/.config

# Copy container entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the container entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

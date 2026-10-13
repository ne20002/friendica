# .devcontainer/Dockerfile

# Start from the official Node.js dev container image
FROM mcr.microsoft.com/devcontainers/javascript-node:24

# Install system dependencies your project requires
# Combining commands reduces image layers
RUN apt-get update && apt-get install -y \
    postgresql-client \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

# Install global npm packages used across the project
RUN npm install -g typescript ts-node nodemon

# Create directory for VS Code extensions cache
# This speeds up container rebuilds
RUN mkdir -p /home/node/.vscode-server/extensions

# Set working directory
WORKDIR /workspace

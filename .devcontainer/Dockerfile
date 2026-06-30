FROM mcr.microsoft.com/devcontainers/javascript-node:22

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl jq git bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

WORKDIR /workspaces

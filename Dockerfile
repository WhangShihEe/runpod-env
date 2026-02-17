FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system tools (git already included in RunPod images)
RUN apt-get update && apt-get install -y tmux && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js (required for Claude Code and code-server)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/ && \
    mv /root/.local/bin/uvx /usr/local/bin/

# Install Claude Code (CLI tool)
RUN npm install -g @anthropic-ai/claude-code

# Install code-server (VS Code in browser)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install VS Code extensions
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter && \
    code-server --install-extension mhutchie.git-graph && \
    code-server --install-extension anthropic.claude-code

# Git config
RUN git config --global init.defaultBranch main

# Environment variables
ENV PATH="/usr/local/bin:$PATH"

# Expose code-server port
EXPOSE 8080

# Set working directory
WORKDIR /workspace

# Default command
CMD ["sleep", "infinity"]

FROM python:3.12-slim AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PRE_COMMIT_HOME=/tmp/pre-commit-cache \
    XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share \
    XDG_STATE_HOME=/root/.local/state \
    PATH="/usr/local/go/bin:/go/bin:${PATH}" \
    GOPATH="/go" \
    EDITOR=nvim

# -------------------
# Development tools
# -------------------
FROM base AS development

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    make \
    curl \
    wget \
    unzip \
    ripgrep \
    fd-find \
    tar \
    gcc \
    g++ \
    cmake \
    clang \
    pkg-config \
    ca-certificates \
    sudo && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Install Go 1.21.5
RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
    rm go1.21.5.linux-amd64.tar.gz && \
    /usr/local/go/bin/go version

# Install lazygit
RUN go install github.com/jesseduffield/lazygit@latest

# Install Neovim 0.11.4
RUN wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

# Install Node.js 20.x (for LSPs)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js language servers
RUN npm install -g \
    pyright@latest \
    typescript-language-server \
    typescript

# Verify Node.js installation
RUN echo "Node version:" && node --version && \
    echo "NPM version:" && npm --version && \
    echo "Pyright version:" && pyright --version

# Install Python language servers and formatters
RUN pip install --no-cache-dir \
    black \
    isort \
    flake8 \
    debugpy \
    pynvim

# Create necessary directories with proper permissions
RUN mkdir -p \
    ${XDG_DATA_HOME}/nvim/lazy \
    ${XDG_DATA_HOME}/nvim/mason \
    ${XDG_STATE_HOME}/nvim \
    ${XDG_CONFIG_HOME}/nvim \
    ${XDG_CONFIG_HOME}/lazygit

# Copy your nvim configuration from the repo
COPY nvim/ ${XDG_CONFIG_HOME}/nvim/

# Optional: Copy lazygit config if you have one
# COPY lazygit/ ${XDG_CONFIG_HOME}/lazygit/

# Pre-install nvim plugins (headless mode)
# This reduces startup time on first use
RUN nvim --headless "+Lazy! sync" +qa || true

# Install Mason LSP servers if you use Mason
RUN nvim --headless "+MasonInstallAll" +qa 2>/dev/null || true

# Set working directory
WORKDIR /workspace

# Health check
RUN nvim --version && \
    lazygit --version && \
    go version && \
    python --version

CMD ["/bin/bash"]

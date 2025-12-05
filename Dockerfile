FROM mcr.microsoft.com/vscode/devcontainers/python:3.12

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share \
    XDG_STATE_HOME=/root/.local/state \
    PATH="/usr/local/go/bin:/go/bin:${PATH}" \
    GOPATH="/go" \
    EDITOR=nvim

# Install only what's missing (minimal downloads)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    ripgrep \
    fd-find \
    unzip \
    tar && \
    rm -rf /var/lib/apt/lists/*

# Install Go 1.21.5
RUN wget --no-check-certificate https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
    rm go1.21.5.linux-amd64.tar.gz

# Install lazygit (pre-built binary, no Go proxy needed)
RUN curl -kLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    rm -f lazygit.tar.gz lazygit

# Install Neovim 0.11.4
RUN wget --no-check-certificate https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

# Install Python tools (pip usually works even in corporate networks)
RUN pip install --no-cache-dir \
    black \
    isort \
    flake8 \
    debugpy \
    pynvim

# Node.js is already installed in the base image
# Install Node.js language servers
RUN npm install -g \
    pyright@latest \
    typescript-language-server \
    typescript || echo "npm install failed, but continuing..."

# Create necessary directories
RUN mkdir -p \
    ${XDG_DATA_HOME}/nvim/lazy \
    ${XDG_DATA_HOME}/nvim/mason \
    ${XDG_STATE_HOME}/nvim \
    ${XDG_CONFIG_HOME}/nvim

# Copy your nvim configuration
COPY nvim/ ${XDG_CONFIG_HOME}/nvim/

# Pre-install nvim plugins (best effort)
RUN nvim --headless "+Lazy! sync" +qa || true

# Set working directory
WORKDIR /workspace

CMD ["/bin/bash"]

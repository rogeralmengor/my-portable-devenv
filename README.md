# 🚀 My Portable Dev Environment

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Neovim](https://img.shields.io/badge/NeoVim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://golang.org/)

> A fully containerized development environment with Neovim, LazyGit, and LSP support. Work anywhere, same setup everywhere.

## ✨ Features

- 🎯 **Portable** - Clone and run on any machine with Docker
- ⚡ **Fast** - Pre-configured with Lazy.nvim for blazing fast startup
- 🛠️ **Complete** - Python, Go, Node.js, and all LSPs included
- 🎨 **Customizable** - Full Neovim config in Lua
- 🔄 **Git-Powered** - LazyGit integration for seamless version control
- 🌐 **Corporate-Friendly** - Works behind firewalls and proxies

## 📦 What's Inside

| Tool | Version | Purpose |
|------|---------|---------|
| **Neovim** | 0.11.4 | Your main editor |
| **LazyGit** | 0.40.2 | Git management TUI |
| **Python** | 3.12 | Primary language |
| **Go** | 1.21.5 | Systems programming |
| **Node.js** | 20.x | JavaScript/TypeScript |

### Language Support

- **Python**: black, isort, flake8, debugpy, Pyright LSP
- **JavaScript/TypeScript**: typescript-language-server
- **Go**: Native Go tooling
- **More**: ripgrep, fd-find for fast search

## 🚀 Quick Start

```bash
# Clone this repo
git clone https://github.com/rogeralmengor/my-portable-devenv.git
cd my-portable-devenv

# Build the image
docker-compose build

# Start coding!
docker-compose run --rm devenv
```

Inside the container:
```bash
nvim .        # Open Neovim
lazygit       # Manage Git
python        # Run Python
go            # Run Go
```

## 💻 Usage in Projects

### Method 1: Standalone Dockerfile

Copy just the `Dockerfile` to your project:

```bash
# Your project
docker build -t devenv .
docker run -it -v $(pwd):/workspace devenv
```

### Method 2: Pre-built Image

Build once, use everywhere:

```bash
# Build in this repo
docker-compose build

# Use in any project
cd /path/to/your-project
docker run -it -v $(pwd):/workspace my-portable-devenv:latest
```

## 🎨 Neovim Configuration

Neovim config is automatically cloned from this repository during build. Your plugins include:

- **Lazy.nvim** - Plugin manager
- **LSP** - Language Server Protocol support
- **Treesitter** - Syntax highlighting
- **Telescope** - Fuzzy finder
- **And more** - Check `nvim/lua/plugins/`

## 🔄 Updating Configuration

1. Edit your Neovim config in `nvim/`
2. Commit and push to GitHub
3. Rebuild the image:

```bash
docker-compose build
```

Your new config is automatically included!

## 🛠️ Customization

### Add More Tools

Edit the `Dockerfile`:

```dockerfile
# Add system packages
RUN apt-get install -y your-tool

# Add Python packages
RUN pip install your-package

# Add Node packages
RUN npm install -g your-package
```

### Change Neovim Config

Your config lives in `nvim/`. Edit any file:

```
nvim/
├── init.lua              # Main config
├── lua/
│   ├── vim-options.lua   # Vim settings
│   └── plugins/          # Plugin configs
```

## 🌍 Why Docker?

- ✅ **Consistent** - Same environment on Windows, Mac, Linux
- ✅ **Isolated** - Doesn't mess with your host system
- ✅ **Portable** - Share with teammates instantly
- ✅ **Reproducible** - Same setup every time

## 📝 Windows Users

Use PowerShell:

```powershell
# Build
docker-compose build

# Run
docker-compose run --rm devenv
```

Your files automatically mount to `/workspace` in the container.

## 🤝 Contributing

This is my personal dev environment, but feel free to fork and customize!

1. Fork the repo
2. Create your feature branch
3. Commit your changes
4. Push and open a PR

## 📄 License

MIT License - Use freely, modify as needed.

## 🙏 Acknowledgments

Built with:
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin manager
- [LazyGit](https://github.com/jesseduffield/lazygit) - Simple terminal UI for git
- [VS Code Dev Containers](https://github.com/devcontainers) - Base image

---

<div align="center">

**Made with ❤️ and Lua**

[⭐ Star this repo](https://github.com/rogeralmengor/my-portable-devenv) if you find it useful!

</div>
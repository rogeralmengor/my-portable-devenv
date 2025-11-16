# 🚀 My Portable Neovim Development Environment

A complete, batteries-included Neovim configuration designed for Python development with a focus on productivity, aesthetics, and portability across Windows and Linux environments (including Docker containers).

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

---

## ✨ Features

### 🎨 **Beautiful UI & Themes**
- **Multiple colorschemes**: OneDark (default), Gruvbox, Catppuccin, Everforest, Bamboo
- **Semi-transparent background** with custom color overrides
- **Professional cursor styling** with mode-specific colors and shapes:
  - Normal/Visual: Blue block cursor
  - Insert: Green thin vertical line
  - Replace: Red horizontal line
  - Command: Yellow cursor
- **Enhanced statusline** with Lualine
- **Buffer tabs** with Bufferline for easy file navigation

### 🔧 **Developer Tools**
- **LSP Integration** (pyright, typescript-language-server) with auto-completion
- **Code formatting** with Black, isort, flake8
- **Debugging** support with DAP (debugpy for Python)
- **Git integration** with Lazygit, Neogit, and git-stuff
- **Pytest integration** for running Python tests directly in Neovim
- **Goto preview** for quick definition/reference viewing
- **Code folding** with enhanced fold display
- **Syntax highlighting** with Treesitter

### 📁 **File Management**
- **Neo-tree** file explorer with custom icons
- **Telescope** fuzzy finder for files, buffers, and grep search
- **Terminal integration** with toggleable floating terminal

### 🎯 **Quality of Life**
- **Auto-pairs** for brackets, quotes, and parentheses
- **Comment.nvim** for easy line/block commenting
- **Indent guides** for better code readability
- **Yank highlighting** with 500ms visual feedback
- **Auto-centering** cursor after vertical movements (j/k)
- **OSC 52 clipboard support** for Docker/SSH environments
- **No swap files** for cleaner workspace

### 🎮 **Fun Extras**
- **Vim-be-good** - A game to practice Vim motions!
- **Noice + Trouble** - Beautiful command-line UI and diagnostics

---

## 📋 Prerequisites

Before installing this configuration, ensure you have:

- **Neovim 0.10+** (this config was tested with v0.11.4)
- **Git** (for cloning the repo and Lazy.nvim plugin manager)
- **Node.js 20+** (for LSP servers like pyright)
- **Python 3.8+** with pip (for Python LSP and formatters)
- **Ripgrep** (for Telescope live grep)
- **A Nerd Font** (recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font)

### Optional but Recommended:
- **fd** (faster file finding for Telescope)
- **Lazygit** (for the git integration)
- **gcc/g++** (for Treesitter compilation)

---

## 🚀 Installation

### Quick Install (Linux/macOS/WSL)

```bash
# Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Clone this configuration
git clone https://github.com/rogeralmengor/my-portable-devenv.git ~/.config/my-portable-devenv
cp -r ~/.config/my-portable-devenv/nvim ~/.config/nvim

# Launch Neovim (plugins will auto-install on first run)
nvim
```

### Windows Installation

```powershell
# Backup your existing config (if any)
Move-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim.backup" -ErrorAction SilentlyContinue
Move-Item -Path "$env:LOCALAPPDATA\nvim-data" -Destination "$env:LOCALAPPDATA\nvim-data.backup" -ErrorAction SilentlyContinue

# Clone this configuration
git clone https://github.com/rogeralmengor/my-portable-devenv.git "$env:LOCALAPPDATA\my-portable-devenv"
Copy-Item -Recurse "$env:LOCALAPPDATA\my-portable-devenv\nvim" -Destination "$env:LOCALAPPDATA\nvim"

# Launch Neovim
nvim
```

### Docker/Container Installation

This configuration works seamlessly in Docker containers. Add to your Dockerfile:

```dockerfile
# Install Neovim and dependencies
RUN wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

# Install Node.js for LSP
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install LSP servers
RUN npm install -g pyright typescript-language-server

# Install Python tools
RUN pip install --no-cache-dir black isort flake8 debugpy pynvim

# Clone your Neovim config
RUN git clone https://github.com/rogeralmengor/my-portable-devenv.git /tmp/nvim-config && \
    mkdir -p /root/.config && \
    cp -r /tmp/nvim-config/nvim /root/.config/ && \
    rm -rf /tmp/nvim-config

# Pre-install plugins (optional but recommended)
RUN nvim --headless "+Lazy! sync" +qa || true
```

---

## 📦 Included Plugins

### Core Functionality
| Plugin | Purpose |
|--------|---------|
| `lazy.nvim` | Plugin manager |
| `telescope.nvim` | Fuzzy finder for files, buffers, grep |
| `neo-tree.nvim` | File explorer sidebar |
| `nvim-treesitter` | Advanced syntax highlighting |
| `lsp-config` | LSP client configuration |
| `nvim-cmp` | Auto-completion engine |

### Git Integration
| Plugin | Purpose |
|--------|---------|
| `lazygit.nvim` | Lazygit integration |
| `neogit` | Git interface in Neovim |
| `git-stuff` | Additional git utilities |

### Development Tools
| Plugin | Purpose |
|--------|---------|
| `none-ls` | Formatting and linting |
| `nvim-dap` | Debugging adapter protocol |
| `pytest.nvim` | Python test runner |
| `goto-preview` | Preview definitions/references in floating window |

### UI Enhancement
| Plugin | Purpose |
|--------|---------|
| `lualine.nvim` | Statusline |
| `bufferline.nvim` | Tab-like buffer line |
| `indent-blankline` | Indent guides |
| `noice.nvim` | Beautiful command-line UI |
| `nvim-notify` | Notification manager |
| `trouble.nvim` | Diagnostics and quickfix list |

### Themes
- `onedark.nvim` (default)
- `gruvbox.nvim` + `sainnhe/gruvbox`
- `catppuccin`
- `everforest`
- `bamboo.nvim`

### Utilities
| Plugin | Purpose |
|--------|---------|
| `nvim-autopairs` | Auto-close brackets/quotes |
| `Comment.nvim` | Easy commenting |
| `toggleterm.nvim` | Floating terminal |
| `vim-be-good` | Vim motion practice game |
| `fold` | Enhanced folding |

---

## ⌨️ Key Bindings

### Leader Key
The leader key is set to **`<Space>`**

### Essential Keymaps

#### General
| Key | Mode | Action |
|-----|------|--------|
| `<leader>y` | Normal/Visual | Yank to system clipboard (OSC 52) |
| `<leader>Y` | Normal/Visual | Yank line to system clipboard |
| `<leader>p` | Normal/Visual | Paste |
| `<leader>P` | Normal/Visual | Paste before cursor |
| `<Alt-j>` | Visual | Move selected block down |
| `<Alt-k>` | Visual | Move selected block up |
| `j` / `k` | Normal | Move and center cursor |

#### Terminal
| Key | Mode | Action |
|-----|------|--------|
| `<C-w>` | Terminal | Exit terminal mode and switch windows |

#### LSP & Navigation
| Key | Mode | Action |
|-----|------|--------|
| `<leader>pd` | Normal | Preview definition in floating window |

#### Git (Lazygit)
| Key | Mode | Action |
|-----|------|--------|
| `<C-j>` | Terminal | Navigate down in Lazygit |
| `<C-k>` | Terminal | Navigate up in Lazygit |

*Note: Many more keybindings are available through the individual plugins. Type `:Telescope keymaps` to see all available mappings.*

---

## 🎨 Customization

### Changing Colorscheme

By default, the config uses **OneDark**. To change it:

1. Open `~/.config/nvim/init.lua`
2. Find the line: `vim.cmd.colorscheme("onedark")`
3. Replace with one of:
   - `gruvbox`
   - `catppuccin`
   - `everforest`
   - `bamboo`

### Adjusting Transparency

The semi-transparent background can be adjusted in `init.lua`:

```lua
vim.api.nvim_set_hl(0, "Normal", { bg = "#1d2021" })  -- Change this hex value
```

### Modifying Tab Width

Edit `~/.config/nvim/lua/vim-options.lua`:

```lua
vim.cmd("set tabstop=2")      -- Visual width of tab character
vim.cmd("set softtabstop=2")  -- Spaces inserted when pressing Tab
vim.cmd("set shiftwidth=2")   -- Spaces used for auto-indent
```

---

## 🐳 Docker Usage Example

This configuration is optimized for Docker containers. Here's a complete example:

```dockerfile
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl wget unzip ripgrep fd-find tar gcc g++ \
    cmake clang pkg-config ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Neovim 0.11.4
RUN wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install LSP servers
RUN npm install -g pyright typescript-language-server

# Install Python formatters
RUN pip install --no-cache-dir black isort flake8 debugpy pynvim

# Clone Neovim config
RUN git clone https://github.com/rogeralmengor/my-portable-devenv.git /tmp/nvim-config && \
    mkdir -p /root/.config && \
    cp -r /tmp/nvim-config/nvim /root/.config/ && \
    rm -rf /tmp/nvim-config

# Pre-install plugins
RUN nvim --headless "+Lazy! sync" +qa || true

# Set environment variables
ENV XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share \
    XDG_STATE_HOME=/root/.local/state

CMD ["bash"]
```

---

## 🔧 Troubleshooting

### Plugins not loading
```bash
# Inside Neovim
:Lazy sync
:Lazy restore
```

### LSP not working
```bash
# Verify installations
:checkhealth
:LspInfo
```

### Clipboard not working in Docker/SSH
The config uses OSC 52 for clipboard support. Ensure your terminal supports OSC 52:
- Windows Terminal ✅
- iTerm2 ✅
- Alacritty ✅
- Kitty ✅

### Python LSP issues
```bash
# Ensure pyright is installed
npm list -g pyright

# Reinstall if needed
npm install -g pyright
```

---

## 📝 Configuration Structure

```
nvim/
├── init.lua                 # Main config entry point
├── lua/
│   ├── vim-options.lua     # Basic Vim settings
│   └── plugins/            # Plugin configurations
│       ├── lsp-config.lua
│       ├── telescope.lua
│       ├── neo-tree.lua
│       ├── treesitter.lua
│       ├── completions.lua
│       ├── debugging.lua
│       ├── lazygit.lua
│       ├── pytest.lua
│       └── ... (28 total plugins)
```

---

## 🤝 Contributing

Found a bug or want to suggest an improvement? Feel free to open an issue or submit a pull request!

---

## 📄 License

This configuration is provided as-is for personal and educational use.

---

## 🙏 Acknowledgments

Special thanks to the Neovim community and all the plugin authors who make this configuration possible!

---

## 🔗 Useful Links

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Awesome Neovim Plugins](https://github.com/rockerBOO/awesome-neovim)

---

**Made with ❤️ for developers who love the terminal**:wq

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ruff" },
        automatic_installation = false,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Modern Neovim 0.11+ approach using vim.lsp.config
      -- Setup lua_ls
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        filetypes = { "lua" },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- Setup Pyright for autocompletion and type checking
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        filetypes = { "python" },
        capabilities = capabilities,
        settings = {
          pyright = {
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      }

      -- Setup Ruff for linting, formatting, and import organizing
      vim.lsp.config.ruff = {
        cmd = { "ruff", "server" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        filetypes = { "python" },
        capabilities = capabilities,
        settings = {
          -- Ruff settings will be picked up from pyproject.toml
        },
      }

      -- Enable the LSP servers
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruff")

      -- Disable Ruff's hover capability in favor of Pyright
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = "LSP: Disable hover capability from Ruff",
      })

      -- Keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      
      -- -- Diagnostic keymaps
      -- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
      -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
      -- 
      -- Organize imports
      vim.keymap.set(
        "n",
        "<leader>oi",
        "<cmd>lua vim.lsp.buf.code_action({context = {only = {'source.organizeImports'}}, apply = true})<CR>",
        { desc = "Organize imports" }
      )
    end,
  },
}

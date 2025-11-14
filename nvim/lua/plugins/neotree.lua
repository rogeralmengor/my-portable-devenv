return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({
          default = true,
          override = {
            -- Programming files
            py = { icon = "", color = "#306998", name = "Python" }, -- Python blue
            lua = { icon = "", color = "#51A0CF", name = "Lua" }, -- Lua
            js = { icon = "", color = "#F0DB4F", name = "JavaScript" },
            ts = { icon = "", color = "#007ACC", name = "TypeScript" },
            rb = { icon = "", color = "#CC342D", name = "Ruby" },
            go = { icon = "", color = "#00ADD8", name = "Go" },
            -- Folders
            Folder = { icon = "", color = "#FFD700", name = "Folder" }, -- closed folder gold
            FolderOpen = { icon = "", color = "#FFA500", name = "FolderOpen" }, -- open folder orange
            -- Git icons
            git = { icon = "", color = "#F14C28", name = "Git" },
          },
        })
      end,
    },
  },
  config = function()
    -- Toggle Neo-tree with <leader>e
    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })
    -- Manual refresh
    vim.keymap.set("n", "<leader>r", "<cmd>Neotree refresh<CR>", { noremap = true, silent = true })

    -- Neo-tree setup
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = false,
      filesystem = {
        follow_current_file = { enabled = true},
        use_libuv_file_watcher = true, -- prevent flickering
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none", -- prevents accidental collapse
        },
      },
    })
  end,
}

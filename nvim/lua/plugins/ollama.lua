return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Always use the latest version for local LLM improvements
  build = "make",  -- Builds the local repository parser (no Docker required)
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- Optional, for icons
    {
      "hrsh7th/nvim-cmp", 
      optional = true,
    }
  },
  opts = {
    provider = "gemini",
    auto_suggestions_provider = "gemini", -- Enables Copilot-like inline suggestions

    -- New Migrated Providers Structure
    providers = {
      gemini = {
        model = "gemini-3.5-flash", -- Highly stable, incredibly fast, and active
        timeout = 30000,
        extra_request_body = {
          temperature = 0,
        },
      },
    },

    -- Remapped submit keys to use Enter (<CR>) instead of Ctrl+S
    mappings = {
      submit = {
        normal = "<CR>",
        insert = "<CR>",
      },
    },

    -- Disable the Docker-based RAG service
    rag_service = {
      enabled = false,
    },

    behaviour = {
      auto_suggestions = true, -- Enable inline ghost text suggestions while typing
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
  },
  config = function(_, opts)
    require("avante").setup(opts)

    -- Visual Mode: Select code and press <leader>eq to ask questions about it
    vim.keymap.set("v", "<leader>eq", function()
      vim.cmd("AvanteAsk")
    end, { desc = "AI: Ask question about selection" })

    -- Visual Mode: Select code and press <leader>ee to modify/refactor it directly
    vim.keymap.set("v", "<leader>ee", function()
      vim.cmd("AvanteEdit")
    end, { desc = "AI: Edit selection directly" })

    -- Normal Mode: Focus or toggle the sidebar chat
    vim.keymap.set("n", "<leader>gc", function()
      vim.cmd("AvanteToggle")
    end, { desc = "AI: Toggle Sidebar Chat" })
  end
}

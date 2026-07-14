return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Always use the latest version for local LLM improvements
  build = "make",  -- Builds the internal parser for codebase search
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
    provider = "ollama",
    auto_suggestions_provider = "ollama", -- Enables Copilot-like inline suggestions
    
    -- Corrected structure using the new 'providers' table instead of 'vendors'
    providers = {
      ollama = {
        __inherited_from = "openai",
        api_key_name = "", -- Empty string bypasses the API key check
        endpoint = "http://127.0.0.1:11434/v1",
        model = "qwen2.5-coder:7b", -- Main LLM for code generation and chat
      },
    },

    -- Local RAG configuration to read your entire project
    rag_service = {
      enabled = true,
      provider = "ollama",
      llm_model = "qwen2.5-coder:7b",
      embed_model = "nomic-embed-text", -- Text embedding model to index your codebase
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
    -- We set a dummy environment variable here to prevent the RAG service 
    -- from crashing if it checks for an OpenAI key before initializing Ollama.
    if vim.fn.getenv("OPENAI_API_KEY") == vim.NIL then
      vim.fn.setenv("OPENAI_API_KEY", "dummy-key-for-local-ollama")
    end

    require("avante").setup(opts)

    -- Custom Keymaps (English descriptions)
    
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

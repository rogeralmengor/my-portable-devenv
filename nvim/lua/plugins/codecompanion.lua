return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Current CodeCompanion API: "interactions" (formerly "strategies")
    interactions = {
      chat   = { adapter = { name = "ollama", model = "qwen2.5-coder:7b" } },
      inline = { adapter = { name = "ollama", model = "qwen2.5-coder:7b" } },
      cmd    = { adapter = { name = "ollama", model = "qwen2.5-coder:7b" } },
    },
    adapters = {
      -- Adapters now live under adapters.http, and are built with extend() (not use())
      http = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              -- also honours the OLLAMA_HOST env var set in docker-compose
              url = "http://host.docker.internal:11434",
            },
            schema = {
              model = { default = "qwen2.5-coder:7b" },
            },
          })
        end,
      },
    },
  },
}

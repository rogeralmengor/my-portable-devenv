return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = true,
  opts = {
    strategies = {
      chat = {
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
      },
    },
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").use("ollama", {
          schema = {
            model = {
              default = "qwen2.5-coder:7b",
            },
          },
          env = {
            url = "http://host.docker.internal:11434",
          },
        })
      end,
    },
  },
}

return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").use("ollama", {
            schema = {
              model = { default = "qwen2.5-coder:7b" },
            },
            env = {
              url = "http://host.docker.internal:11434",
            },
          })
        end,
      },
    })

    -- Toggle AI Chat buffer using CodeCompanion's built-in Lua API
    vim.keymap.set({ "n", "v" }, "<leader>ac", function()
      require("codecompanion").toggle()
    end, { desc = "Toggle AI Chat" })
  end,
}

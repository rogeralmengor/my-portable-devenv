return {
  "olimorris/codecompanion.nvim",
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

    -- Keymap to toggle CodeCompanion chat easily in Normal or Visual mode
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle AI Chat" })
  end,
}

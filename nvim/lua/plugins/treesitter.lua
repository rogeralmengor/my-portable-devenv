return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      -- Parsers you specifically requested
      ensure_installed = { "python", "xml", "lua", "markdown", "bash" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

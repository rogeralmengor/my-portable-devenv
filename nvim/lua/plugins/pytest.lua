return {
  "richardhapb/pytest.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
  config = function(_, opts)
    -- Simply initialize pytest; Treesitter is handled in its own file
    require('pytest').setup(opts)
  end
}

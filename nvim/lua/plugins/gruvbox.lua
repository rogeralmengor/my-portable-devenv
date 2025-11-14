return {
  {
    'morhetz/gruvbox',
    config = function()
      vim.cmd('colorscheme gruvbox')
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.cmd(':highlight NeogitDiffAddHighlight guifg=#000000 guibg=#b8bb26')
    end
  },
  { 'luisiacc/gruvbox-baby' },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
}

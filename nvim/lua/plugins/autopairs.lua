return {
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,       -- integrate with treesitter
      enable_check_bracket_line = true,
      fast_wrap = {},        -- optional: enable fast wrapping
    })
  end
}

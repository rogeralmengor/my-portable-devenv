return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│",      -- vertical line
      tab_char = "▏",  -- thin line for tabs (optional)
    },
    scope = {
      enabled = true,  -- show current scope
      show_start = true,
      show_end = true,
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end
}

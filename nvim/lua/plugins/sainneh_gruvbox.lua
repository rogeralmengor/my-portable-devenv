return {
  {"sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark"
    -- This sets the background to a darker variant.
    -- Other options are "soft" or "hard"
    vim.g.gruvbox_material_background = "medium"
    vim.cmd.colorscheme("gruvbox-material")
  end,
},
{
  "rebelot/kanagawa.nvim"
}
}

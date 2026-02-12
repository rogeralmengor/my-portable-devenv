return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. CONFIGURATION
      vim.o.background = "dark"
      vim.g.gruvbox_material_background = "hard" -- Changed to 'hard' for higher contrast
      vim.g.gruvbox_material_enable_italic = 1   -- Enable italics globally
      vim.g.gruvbox_material_enable_bold = 1

      -- 2. CUSTOM HIGHLIGHTS (The Fixer)
      -- This autocmd runs right after the colorscheme loads to overwrite specific colors
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("custom_highlights_gruvbox", {}),
        pattern = "gruvbox-material",
        callback = function()
          -- A. KILL THE CYAN (Command Line & Messages)
          -- Replaces the cyan borders in Noice/Command line with Gruvbox Orange
          vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "GruvboxOrange" })
          vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { link = "GruvboxOrange" })
          vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { link = "GruvboxOrange" })
          -- Replaces cyan in "Press Enter" messages
          vim.api.nvim_set_hl(0, "MoreMsg", { link = "GruvboxOrange" })
          vim.api.nvim_set_hl(0, "Question", { link = "GruvboxOrange" })

          -- B. FORCE CURSIVE / ITALICS
          -- Forces keywords like 'if', 'else', 'return' to be italic
          vim.api.nvim_set_hl(0, "Keyword", { link = "GruvboxRedItalic" })
          vim.api.nvim_set_hl(0, "Conditional", { link = "GruvboxRedItalic" })
          vim.api.nvim_set_hl(0, "Repeat", { link = "GruvboxRedItalic" })
          -- Forces 'function' keyword to be italic
          vim.api.nvim_set_hl(0, "Function", { link = "GruvboxGreenItalic" })
        end
      })

      -- 3. LOAD THEME
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}

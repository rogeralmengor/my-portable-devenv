return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    -- 1. Configuration: Set Contrast and Italics BEFORE loading the colorscheme
    vim.g.gruvbox_material_background = 'hard' -- The "Hard" contrast you wanted
    vim.g.gruvbox_material_foreground = 'material'
    vim.g.gruvbox_material_enable_italic = 1 -- Enable italics generally
    vim.g.gruvbox_material_enable_bold = 1

    -- 2. Custom Highlight Overrides (The "Cyan Killer")
    -- We use an autocmd to ensure these apply *after* the theme loads.
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("custom_highlights_gruvbox", {}),
      pattern = "gruvbox-material",
      callback = function()
        local config = vim.fn['gruvbox_material#get_configuration']()
        local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground, config.colors_override)
        local set_hl = vim.fn['gruvbox_material#highlight']

        -- A. Fix the "Horrible Cyan" Command Line Borders (Noice.nvim / Dressing.nvim)
        -- We force them to link to Orange (GruvboxOrange) or Foreground (GruvboxFg1)
        vim.cmd("hi! link NoiceCmdlinePopupBorder GruvboxOrange")
        vim.cmd("hi! link NoiceCmdlineIcon GruvboxOrange")
        vim.cmd("hi! link NoiceCmdlinePopupTitle GruvboxOrange")

        -- B. Fix "Messages" Cyan
        -- 'MoreMsg' and 'Question' are usually the culprits for cyan text in messages
        vim.cmd("hi! link MoreMsg GruvboxOrange")
        vim.cmd("hi! link Question GruvboxOrange")

        -- C. Ensure Cursive Italics for Keywords
        -- This forces specific keywords to use the 'Italic' font style
        vim.cmd("hi! link Keyword Italic")
        vim.cmd("hi! link Statement Italic")
        vim.cmd("hi! link Function Italic")
      end
    })

    -- 3. Load the colorscheme
    vim.cmd('colorscheme gruvbox-material')
  end
},

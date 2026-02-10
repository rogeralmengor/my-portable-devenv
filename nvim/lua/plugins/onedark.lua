return {
  "navarasu/onedark.nvim",
  priority = 1000, -- Load this first
  config = function()
    require('onedark').setup({
      -- Set the style to 'warmer' as requested
      style = 'warmer', 
      transparent = false,     -- Set to true if you want a transparent background
      term_colors = true,      -- Match terminal colors to the theme
      ending_tildes = false,   -- Hide the ~ at the end of the buffer
      cmp_itemkind_reverse = false,

      -- Code style customization
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
      },

      -- Plugin specific overrides
      lualine = {
        transparent = false,
      },

      diagnostics = {
        darker = true,     -- Makes diagnostic background colors softer
        undercurl = true,   -- Use curly underlines for errors
        background = true,  -- Use background color for virtual text
      },
    })

    -- IMPORTANT: You must call .load() after .setup() to apply the theme
    require('onedark').load()
  end
}

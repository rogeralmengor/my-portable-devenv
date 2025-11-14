
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      options = { theme = 'everforest' },
      sections = {
        lualine_x = {
          {
            function()
              local rec = vim.fn.reg_recording()
              if rec == '' then return '' end
              return '● REC @' .. rec
            end,
            color = { fg = '#ff5f5f', gui = 'bold' },
          }
        }
      }
    })
  end
}


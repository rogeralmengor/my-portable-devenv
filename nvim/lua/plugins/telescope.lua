return {
  {'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = "Telescope definitions" })
    vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = "Telescope references" })
  end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown{
            }
          }
        }
    })
    require("telescope").load_extension("ui-select")
    end
  },
}

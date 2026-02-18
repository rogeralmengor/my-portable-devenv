return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "codellama:7b-instruct",
    display_mode = "float",
    width = 50,      -- Ancho de la ventana
    height = 25,     -- Alto de la ventana
    window_config = {
      relative = 'editor',
      row = 2,
      col = vim.o.columns - 55,
      border = 'rounded'
    },
  },
  config = function(_, opts)
    require('gen').setup(opts)

    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      if vim.fn.mode():find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      local prompt = vim.fn.input("Ask to  Ollama: ")
      if prompt ~= "" then
        require('gen').exec({ prompt = prompt })
      end
    end, { desc = "Ollama: Preguntar" })
  end
}

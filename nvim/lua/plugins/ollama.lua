return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b", -- El nuevo modelo experto en código
    display_mode = "float",
    width = 45,
    height = vim.o.lines - 8,
    window_config = {
      relative = 'editor',
      row = 1,
      col = vim.o.columns - 48,
      border = 'rounded',
    },
  },
  config = function(_, opts)
    require('gen').setup(opts)

    -- Tu comando <leader>eq sigue igual, pero ahora usará Qwen
    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      if vim.fn.mode():find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      vim.defer_fn(function()
        local prompt = vim.fn.input("Pregunta (Python/Docker/Jenkins): ")
        if prompt ~= "" then
          require('gen').exec({ prompt = prompt })
        end
      end, 10)
    end, { desc = "Ollama: Preguntar" })
  end
}

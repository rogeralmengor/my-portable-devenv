return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "codellama:7b-instruct",
    display_mode = "float",
    -- Ajustamos el tamaño para que parezca una barra lateral
    width = 45,
    height = vim.o.lines - 8, -- Casi toda la altura de la pantalla
    show_model = true,
    window_config = {
      relative = 'editor',
      row = 1,
      -- Cálculo dinámico: Ancho total menos el ancho de la ventana del plugin
      col = vim.o.columns - 47,
      border = 'rounded',
      style = 'minimal',
    },
  },
  config = function(_, opts)
    require('gen').setup(opts)

    -- Comando para preguntar
    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      -- Fix para la selección visual
      if vim.fn.mode():find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      -- Usamos defer_fn para dar tiempo a Neovim de procesar el Esc
      vim.defer_fn(function()
        local prompt = vim.fn.input("Pregunta a Ollama: ")
        if prompt ~= "" then
          require('gen').exec({ prompt = prompt })
        end
      end, 10)
    end, { desc = "Ollama: Preguntar" })
  end
}

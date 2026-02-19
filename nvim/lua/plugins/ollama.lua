return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "float",
    width = 45,
    height = vim.o.lines - 8,
    window_config = {
      relative = 'editor',
      row = 1,
      col = vim.o.columns - 48, -- Pushes window to the right edge
      border = 'rounded',
    },
  },
  config = function(_, opts)
    require('gen').setup(opts)

    -- FIXED command for explaining selection
    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      -- 1. If in visual mode, exit to finalize the selection marks
      local mode = vim.api.nvim_get_mode().mode
      if mode:find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      -- 2. Short delay to allow Neovim to update selection registers
      vim.defer_fn(function()
        -- Manually grab the selected text
        local start_line = vim.api.nvim_buf_get_mark(0, '<')[1]
        local end_line = vim.api.nvim_buf_get_mark(0, '>')[1]
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local selection = table.concat(lines, "\n")

        -- 3. Prompt user for their question
        local question = vim.fn.input("Ask about the code: ")

        if question ~= "" then
          -- Send a structured prompt: QUESTION + CODE
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question
          })
        end
      end, 10)
    end, { desc = "Ollama: Explain selection" })
  end
}

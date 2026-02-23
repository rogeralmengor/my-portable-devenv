return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "split", -- valid value; we'll force vertical ourselves
    show_model = false,
  },
  config = function(_, opts)
    require('gen').setup(opts)

    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      local mode = vim.api.nvim_get_mode().mode
      if mode:find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      vim.defer_fn(function()
        local start_line = vim.api.nvim_buf_get_mark(0, '<')[1]
        local end_line = vim.api.nvim_buf_get_mark(0, '>')[1]
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local selection = table.concat(lines, "\n")
        local question = vim.fn.input("Ask AI: ")

        if question == "" then return end

        -- Save the current window (your code buffer)
        local code_win = vim.api.nvim_get_current_win()

        -- Check if a gen buffer/window already exists
        local gen_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'gen' then
            gen_win = win
            break
          end
        end

        -- If no gen window, create a vertical split on the right
        if not gen_win then
          vim.cmd('vsplit')
          vim.cmd('enew')
          gen_win = vim.api.nvim_get_current_win()
          -- Return focus to code buffer so gen.nvim opens in the right split
          vim.api.nvim_set_current_win(code_win)
        end

        require('gen').exec({
          prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
        })

        -- Polish: wrap + scroll to bottom after response loads
        vim.defer_fn(function()
          local win = nil
          for _, w in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(w)
            if vim.bo[buf].filetype == 'gen' then
              win = w
              break
            end
          end
          if win then
            vim.wo[win].wrap = true
            local last_line = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
            pcall(vim.api.nvim_win_set_cursor, win, { last_line, 0 })
            -- Return cursor to code buffer
            vim.api.nvim_set_current_win(code_win)
          end
        end, 300)
      end, 10)
    end, { desc = "AI Side-by-Side Chat" })

    -- Focus toggle
    vim.keymap.set('n', '<leader>gc', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end, { desc = "Focus AI window" })
  end
}

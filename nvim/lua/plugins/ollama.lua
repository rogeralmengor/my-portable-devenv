return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "float", -- Satisfies the plugin's check to stop the warning
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

        if question ~= "" then
          -- 1. Check if a chat window already exists
          local chat_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'gen' then
              chat_win = win
              break
            end
          end

          -- 2. If no window, create one. If it exists, just focus it.
          if not chat_win then
            vim.cmd('vsplit')
            vim.cmd('wincmd L')
            vim.cmd('vertical resize 60')
          else
            vim.api.nvim_set_current_win(chat_win)
          end

          -- 3. Execute with 'split' mode to use the current window we just focused
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            display_mode = "split", 
          })

          -- 4. Set the Robot Header and clean UI
          vim.defer_fn(function()
             local buf = vim.api.nvim_get_current_buf()
             vim.wo.wrap = true
             -- Only add header if it's a fresh buffer
             if vim.api.nvim_buf_line_count(buf) <= 2 then
                vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "🤖 AI ASSISTANT", "===================", "" })
             end
          end, 100)
        end
      end, 10)
    end, { desc = "AI Chat Split" })

    -- Jump Focus Toggle
    vim.keymap.set('n', '<leader>gc', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      print("No active chat split.")
    end)
  end
}

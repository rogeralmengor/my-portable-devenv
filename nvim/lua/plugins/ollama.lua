return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "float", 
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
          local chat_win = nil
          local chat_buf = nil

          -- 1. Find existing buffer by filetype
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'gen' then
              chat_buf = buf
              break
            end
          end

          -- 2. Handle window/split logic
          if chat_buf then
            chat_win = vim.fn.bufwinid(chat_buf)
            if chat_win == -1 then -- Buffer exists but window was closed
              vim.cmd('vsplit')
              vim.api.nvim_set_current_buf(chat_buf)
              chat_win = vim.api.nvim_get_current_win()
              vim.cmd('wincmd L')
            else
              vim.api.nvim_set_current_win(chat_win)
            end
          else
            -- First time: Create split and buffer
            vim.cmd('vsplit')
            vim.cmd('wincmd L')
            vim.cmd('vertical resize 60')
            chat_win = vim.api.nvim_get_current_win()
            chat_buf = vim.api.nvim_get_current_buf()
          end

          -- 3. Fix the 'nil' diagnostic: Ensure chat_buf exists before writing
          if chat_buf and vim.api.nvim_buf_is_valid(chat_buf) then
            local last_line = vim.api.nvim_buf_line_count(chat_buf)
            local header = (last_line <= 1) and {"🤖 AI ASSISTANT", "===="} or {"", "---", "❓ " .. question}
            vim.api.nvim_buf_set_lines(chat_buf, last_line, -1, false, header)
            -- Position cursor at the very end
            vim.api.nvim_win_set_cursor(chat_win, {vim.api.nvim_buf_line_count(chat_buf), 0})
          end

          -- 4. Execute and FORCE the use of our current buffer
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            display_mode = "split", 
          })

          vim.defer_fn(function() vim.wo.wrap = true end, 100)
        end
      end, 10)
    end, { desc = "AI Continuous Chat" })

    -- leader gc to focus
    vim.keymap.set('n', '<leader>gc', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end)
  end
}

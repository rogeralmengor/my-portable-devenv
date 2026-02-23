return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "vsplit", -- Use the plugin's native split to stop warnings
    show_model = false,      -- Clean up the header
    width = 55,              -- Set a fixed width for the side-by-side view
  },
  config = function(_, opts)
    require('gen').setup(opts)

    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      -- 1. Handle Visual Selection
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
          -- 2. Find if a chat buffer already exists to keep history
          local chat_buf = nil
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'gen' then
              chat_buf = buf
              break
            end
          end

          -- 3. If it exists, append a separator and the new question
          if chat_buf and vim.api.nvim_buf_is_valid(chat_buf) then
            local last = vim.api.nvim_buf_line_count(chat_buf)
            vim.api.nvim_buf_set_lines(chat_buf, last, -1, false, {
              "", "---", "❓ " .. question, ""
            })
          end

          -- 4. Execute (Plugin handles the vsplit and side-by-side logic)
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
          })

          -- 5. Final Polish: Ensure wrap is on and cursor is at bottom
          vim.defer_fn(function()
            local win = vim.fn.bufwinid(vim.fn.bufnr('gen.nvim'))
            if win ~= -1 then
              vim.wo[win].wrap = true
              local last_line = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
              -- Use pcall to ignore "cursor outside buffer" errors if the AI is too fast
              pcall(vim.api.nvim_win_set_cursor, win, { last_line, 0 })
            end
          end, 200)
        end
      end, 10)
    end, { desc = "AI Side-by-Side Chat" })

    -- Easy Focus Toggle (leader gc)
    vim.keymap.set('n', '<leader>gc', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end)
  end
}

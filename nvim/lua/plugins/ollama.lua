-- Global to keep track of our one and only AI buffer
_G.ai_chat_buf = _G.ai_chat_buf or nil

return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "vsplit", -- Use the native mode the plugin actually supports
    show_model = false,
    width = 60,
  },
  config = function(_, opts)
    require('gen').setup(opts)

    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      -- 1. Selection logic
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
          -- 2. If buffer exists, append a separator first
          if _G.ai_chat_buf and vim.api.nvim_buf_is_valid(_G.ai_chat_buf) then
            local last = vim.api.nvim_buf_line_count(_G.ai_chat_buf)
            vim.api.nvim_buf_set_lines(_G.ai_chat_buf, last, -1, false, {
              "", "---", "❓ " .. question, ""
            })
          end

          -- 3. Execute using native vsplit
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            -- We don't pass display_mode here, let it use the default 'vsplit' from opts
          })

          -- 4. Catch the buffer ID once the plugin creates it
          vim.defer_fn(function()
            local curr_buf = vim.api.nvim_get_current_buf()
            if vim.bo[curr_buf].filetype == 'gen' then
              _G.ai_chat_buf = curr_buf
              vim.wo.wrap = true
              -- Add the robot icon only if it's the very first line
              if vim.api.nvim_buf_line_count(curr_buf) < 5 then
                 vim.api.nvim_buf_set_lines(curr_buf, 0, 0, false, { "🤖 AI ASSISTANT", "===============", "" })
              end
            end
          end, 200)
        end
      end, 10)
    end, { desc = "AI Chat" })

    -- leader gc to toggle focus
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

-- Define a global variable to track the chat buffer across multiple questions
_G.ai_chat_buf = _G.ai_chat_buf or nil

return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "float", -- Keep this so the plugin doesn't complain
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
          local chat_win = nil

          -- 2. Find or Create the Buffer
          if not _G.ai_chat_buf or not vim.api.nvim_buf_is_valid(_G.ai_chat_buf) then
            vim.cmd('vsplit')
            vim.cmd('wincmd L')
            vim.cmd('vertical resize 60')
            _G.ai_chat_buf = vim.api.nvim_get_current_buf()
            -- Set filetype so we can find it later
            vim.bo[_G.ai_chat_buf].filetype = 'gen'
            vim.api.nvim_buf_set_lines(_G.ai_chat_buf, 0, -1, false, { "🤖 AI ASSISTANT", "===================", "" })
          end

          -- 3. Find or Create the Window
          chat_win = vim.fn.bufwinid(_G.ai_chat_buf)
          if chat_win == -1 then
            vim.cmd('vsplit')
            vim.api.nvim_set_current_buf(_G.ai_chat_buf)
            chat_win = vim.api.nvim_get_current_win()
            vim.cmd('wincmd L')
          else
            vim.api.nvim_set_current_win(chat_win)
          end

          -- 4. Append the Question & Separator (Fixing the Nil diagnostic)
          local b = _G.ai_chat_buf -- Local reference to satisfy LSP
          local last_line = vim.api.nvim_buf_line_count(b)
          vim.api.nvim_buf_set_lines(b, last_line, -1, false, { "", "---", "❓ " .. question, "" })

          -- Move cursor to bottom so plugin appends correctly
          local new_last_line = vim.api.nvim_buf_line_count(b)
          vim.api.nvim_win_set_cursor(chat_win, { new_last_line, 0 })

          -- 5. Execute - This is the key: we are already IN the right window/buffer
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            display_mode = "split",
          })

          vim.defer_fn(function()
            vim.wo.wrap = true
            -- Follow the output
            local last = vim.api.nvim_buf_line_count(b)
            vim.api.nvim_win_set_cursor(chat_win, { last, 0 })
          end, 100)
        end
      end, 10)
    end, { desc = "AI Continuous Chat" })

    -- Jump Focus with leader gc
    vim.keymap.set('n', '<leader>gc', function()
      if _G.ai_chat_buf and vim.api.nvim_buf_is_valid(_G.ai_chat_buf) then
        local win = vim.fn.bufwinid(_G.ai_chat_buf)
        if win ~= -1 then
          vim.api.nvim_set_current_win(win)
        end
      end
    end)
  end
}

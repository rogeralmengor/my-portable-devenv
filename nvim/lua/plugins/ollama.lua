return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "float", -- Keep this as default to avoid warnings
  },
  config = function(_, opts)
    require('gen').setup(opts)

    -- Custom function to force a vertical split
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
          -- FORCE a vertical split before executing
          vim.cmd('vsplit')
          vim.cmd('wincmd L') -- Move split to the far right
          
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            display_mode = "split", -- Plugin internal mode for existing window
          })

          -- Final polish: Enable line wrapping in the new chat window
          vim.defer_fn(function()
             vim.wo.wrap = true
             -- Set a nice header with the Robot icon
             local buf = vim.api.nvim_get_current_buf()
             if vim.bo[buf].filetype == 'gen' then
                vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "🤖 AI Assistant Response", "-------------------" })
             end
          end, 100)
        end
      end, 10)
    end, { desc = "AI Split Chat" })

    -- Easy Toggle Focus between Code and Chat
    vim.keymap.set('n', '<leader>gc', function()
      local found_chat = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          found_chat = true
          break
        end
      end
      if not found_chat then
        print("No active AI chat split found.")
      end
    end, { desc = "Jump to AI Chat" })
  end
}

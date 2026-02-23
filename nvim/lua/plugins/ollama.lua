return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "vsplit", -- Changed from 'float' to 'vsplit'
    show_model = true,
    width = 50, -- This now controls the width of the vertical split
  },
  config = function(_, opts)
    require('gen').setup(opts)

    -- Custom function to handle the vertical split setup
    vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
      -- 1. Handle visual selection
      local mode = vim.api.nvim_get_mode().mode
      if mode:find('[vV]') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
      end

      vim.defer_fn(function()
        local start_line = vim.api.nvim_buf_get_mark(0, '<')[1]
        local end_line = vim.api.nvim_buf_get_mark(0, '>')[1]
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local selection = table.concat(lines, "\n")
        
        -- 2. Ask the question
        local question = vim.fn.input("Ask AI: ")

        if question ~= "" then
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
          })
          
          -- 3. Automatically jump to the chat split once it opens
          vim.defer_fn(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == 'gen' then
                vim.api.nvim_set_current_win(win)
                -- Enable line wrapping so the explanation is easy to read
                vim.wo[win].wrap = true
                break
              end
            end
          end, 200)
        end
      end, 10)
    end, { desc = "AI Chat (Vertical Split)" })

    -- Easy Toggle Focus between Code and Chat
    vim.keymap.set('n', '<leader>gc', function()
      local current_win = vim.api.nvim_get_current_win()
      local target_win = nil
      
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'gen' then
          target_win = win
          break
        end
      end

      if target_win then
        if current_win == target_win then
          vim.cmd('wincmd p') -- Jump back to previous (Code)
        else
          vim.api.nvim_set_current_win(target_win) -- Jump to Chat
        end
      else
        print("Chat split not open")
      end
    end, { desc = "Toggle Focus: Code/AI Chat" })
  end
}

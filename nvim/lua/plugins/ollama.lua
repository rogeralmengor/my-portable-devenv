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
      col = vim.o.columns - 48,
      border = 'rounded',
      focusable = true,
    },
  },
  config = function(_, opts)
    require('gen').setup(opts)

    local spinner_frames = { " / ", " — ", " \\ ", " | " }
    local timer = nil

    -- Function to animate the border title
    local function start_border_animation(win_id)
      local idx = 1
      timer = vim.loop.new_timer()
      timer:start(0, 120, vim.schedule_wrap(function()
        if win_id and vim.api.nvim_win_is_valid(win_id) then
          idx = (idx % #spinner_frames) + 1
          -- Robot icon + simple rotating slash
          local title = " 🤖 [" .. spinner_frames[idx] .. "] "
          vim.api.nvim_win_set_config(win_id, { title = title, title_pos = "center" })
        else
          if timer then
            timer:stop(); timer = nil
          end
        end
      end))
    end

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
        local question = vim.fn.input("Ask: ")

        if question ~= "" then
          require('gen').exec({
            prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
            callback = function()
              if timer then
                timer:stop(); timer = nil
              end
              local win_id = vim.fn.bufwinid(vim.fn.bufnr('gen.nvim'))
              if win_id ~= -1 then
                -- Green-ish checkmark when done
                vim.api.nvim_win_set_config(win_id, { title = " 🤖 [✔] ", title_pos = "center" })
              end
            end
          })

          -- Trigger animation once the window exists
          vim.defer_fn(function()
            local win_id = vim.fn.bufwinid(vim.fn.bufnr('gen.nvim'))
            if win_id ~= -1 then start_border_animation(win_id) end
          end, 100)
        end
      end, 10)
    end)

    -- Focus keymap to allow yanking
    vim.keymap.set('n', '<leader>gc', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'gen' then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end, { desc = "Focus Chat" })
  end
}

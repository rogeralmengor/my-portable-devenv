return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder:1.5b",
    display_mode = "split",
    show_model = false,
  },
  config = function(_, opts)
    -- Patch gen.nvim to open vertically by overriding the split command it uses
    local gen = require('gen')

    -- Monkey-patch the internal window open to always use vsplit
    local original_setup = gen.setup
    gen.setup = function(o)
      o = o or {}
      original_setup(o)
    end

    gen.setup(opts)

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

        local code_win = vim.api.nvim_get_current_win()

        -- Check if gen window already exists
        local gen_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'gen' then
            gen_win = win
            break
          end
        end

        if not gen_win then
          -- Force gen.nvim's internal `split` to behave as `vsplit`
          -- by temporarily setting splitbelow=false and using autocmd to convert
          local aug = vim.api.nvim_create_augroup("GenVsplit", { clear = true })
          vim.api.nvim_create_autocmd("BufWinEnter", {
            group = aug,
            once = true,
            callback = function(ev)
              local buf = ev.buf
              if vim.bo[buf].filetype ~= 'gen' then return end
              -- Find the window gen opened (horizontal split)
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == buf and win ~= code_win then
                  local win_height = vim.api.nvim_win_get_height(win)
                  local total_height = vim.o.lines
                  -- If it's a horizontal split (short height), convert to vsplit
                  if win_height < total_height - 5 then
                    -- Close the horizontal split, reopen as vsplit
                    vim.api.nvim_set_current_win(code_win)
                    vim.api.nvim_win_close(win, false)
                    vim.cmd('vsplit')
                    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
                    vim.api.nvim_set_current_win(code_win)
                  end
                  break
                end
              end
              vim.api.nvim_del_augroup_by_id(aug)
            end,
          })
        end

        gen.exec({
          prompt = "Context code:\n```\n" .. selection .. "\n```\n\nQuestion: " .. question,
        })

        vim.defer_fn(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'gen' then
              vim.wo[win].wrap = true
              pcall(vim.api.nvim_win_set_cursor, win, {
                vim.api.nvim_buf_line_count(buf), 0
              })
              vim.api.nvim_set_current_win(code_win)
              break
            end
          end
        end, 300)

      end, 10)
    end, { desc = "AI Side-by-Side Chat" })

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

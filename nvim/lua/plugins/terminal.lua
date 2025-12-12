return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    -- 1. DEFINE SHELL BASED ON OS (Moved here for reliable loading)
    local sysname = vim.loop.os_uname().sysname
    local terminal_shell

    if sysname == "Linux" or sysname == "Darwin" then
      terminal_shell = "bash" -- Or "zsh" if you prefer
    elseif sysname:match("Windows") then
      terminal_shell = "powershell.exe" -- Explicitly set PowerShell
    else
      terminal_shell = "sh"
    end

    local Terminal = require("toggleterm.terminal").Terminal

    require("toggleterm").setup {
      size = 15,
      open_mapping = [[<C-t>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,

      -- 2. USE THE NEWLY DEFINED VARIABLE
      shell = terminal_shell, 

      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        winblend = 3,
      },
    }

    -- ... (rest of your existing code remains unchanged) ...
    vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })

    local function toggle_term(num)
      Terminal:new({ count = num }):toggle()
    end

    for i = 1, 9 do
      vim.keymap.set("n", "<Leader>" .. i, function() toggle_term(i) end, { noremap = true, silent = true })
    end

    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
  end,
}

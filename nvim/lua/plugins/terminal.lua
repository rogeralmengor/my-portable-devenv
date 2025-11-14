return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local Terminal = require("toggleterm.terminal").Terminal

    require("toggleterm").setup {
      size = 15,
      open_mapping = [[<C-t>]], -- main floating terminal
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell, -- taken from init.lua (bash on Linux, pwsh on Windows)
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        winblend = 3,
      },
    }

    -- Fallback mapping (if <C-t> is intercepted by host terminal)
    vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })

    -- Function to toggle any numbered terminal
    local function toggle_term(num)
      Terminal:new({ count = num }):toggle()
    end

    -- Map <leader>1..9 to toggle numbered terminals
    for i = 1, 9 do
      vim.keymap.set("n", "<Leader>" .. i, function() toggle_term(i) end, { noremap = true, silent = true })
    end

    -- Terminal mode navigation (Ctrl-h/j/k/l)
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
  end,
}

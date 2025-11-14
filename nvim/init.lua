-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- splits to the right and bottom 
vim.opt.splitright = true
vim.opt.splitbelow = true


require("vim-options")

-- Setup Lazy with rocks disabled and custom lockfile location
require("lazy").setup("plugins", {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  rocks = {
    enabled = false, -- Disable luarocks to avoid hererocks issues
  },
})


vim.cmd.colorscheme("onedark")

-- 🎨 Semi-transparent background (MUST come after colorscheme)
vim.api.nvim_set_hl(0, "Normal", { bg = "#1d2021" })  -- Dark background
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })  -- Slightly lighter for popups
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1d2021" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#1d2021" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "Folded", { bg = "#282828" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = "#504945" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#282828" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#1d2021" })


vim.o.number = true
vim.o.relativenumber = true
vim.opt.foldenable = true

-- Match colorcolumn with Gruvbox palette
vim.cmd [[
  highlight ColorColumn ctermbg=0 guibg=#3c3836
]]

-- Set shell depending on OS
if vim.fn.has("win32") == 1 then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }
  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
else
  -- Linux / macOS / Docker
  vim.o.shell = "/bin/bash"
end

--vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")
vim.keymap.set('t', '<C-w>', "<C-\\><C-n><C-w>")


vim.o.colorcolumn = "100"


vim.cmd([[highlight NeoTreePython guifg=#306998 guibg=#FFD43B]])

-- Highlight the cursor horizontal line
vim.o.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {bg="#333333"})

-- Move selected block up with Alt-k
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" }
)
-- Move selected block down with Alt-j
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })

--vim.keymap.set("n", "<leader>pd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})

vim.keymap.set("n", "<leader>pd", function()
  require('goto-preview').goto_preview_definition()
end, {noremap=true, desc = "Preview definition"})

-- =====================================================
-- 🎯 PROFESSIONAL CURSOR - WIDTH & COLORS ONLY
-- =====================================================
-- No icons, just clean cursor changes by mode

-- Cursor shapes and blinking
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor",           -- Normal/Visual: Full block
  "i-ci-ve:ver25-iCursor/liCursor",       -- Insert: Thin vertical line (25%)
  "r-cr:hor20-rCursor/lrCursor",          -- Replace: Horizontal line (20%)
  "o:hor50",                               -- Operator: Thick horizontal (50%)
  "a:blinkwait700-blinkoff400-blinkon250", -- Smooth blinking
}

-- Cursor colors by mode
vim.api.nvim_set_hl(0, "Cursor", { bg = "#83a598", fg = "#282828" })   -- Normal: Blue
vim.api.nvim_set_hl(0, "lCursor", { bg = "#83a598", fg = "#282828" })  -- Normal: Blue

vim.api.nvim_set_hl(0, "iCursor", { bg = "#b8bb26", fg = "#282828" })  -- Insert: Green
vim.api.nvim_set_hl(0, "liCursor", { bg = "#b8bb26", fg = "#282828" }) -- Insert: Green

vim.api.nvim_set_hl(0, "rCursor", { bg = "#fb4934", fg = "#282828" })  -- Replace: Red
vim.api.nvim_set_hl(0, "lrCursor", { bg = "#fb4934", fg = "#282828" }) -- Replace: Red

-- Dynamic cursor color change on mode switch
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    
    -- Update cursor color based on mode
    if mode == "n" or mode == "v" or mode == "V" or mode == "" then
      -- Normal/Visual modes: Blue block
      vim.opt.guicursor = {
        "n-v-c:block-Cursor",
        "i-ci-ve:ver25-iCursor",
        "r-cr:hor20-rCursor",
        "a:blinkwait700-blinkoff400-blinkon250",
      }
      vim.api.nvim_set_hl(0, "Cursor", { bg = "#83a598", fg = "#282828" })
      
    elseif mode == "i" or mode == "ic" then
      -- Insert mode: Green thin line
      vim.opt.guicursor = {
        "n-v-c:block-Cursor",
        "i-ci-ve:ver25-iCursor",
        "r-cr:hor20-rCursor",
        "a:blinkwait700-blinkoff400-blinkon250",
      }
      vim.api.nvim_set_hl(0, "iCursor", { bg = "#b8bb26", fg = "#282828" })
      
    elseif mode == "R" then
      -- Replace mode: Red horizontal line
      vim.opt.guicursor = {
        "n-v-c:block-Cursor",
        "i-ci-ve:ver25-iCursor",
        "r-cr:hor20-rCursor",
        "a:blinkwait700-blinkoff400-blinkon250",
      }
      vim.api.nvim_set_hl(0, "rCursor", { bg = "#fb4934", fg = "#282828" })
      
    elseif mode == "c" then
      -- Command mode: Yellow
      vim.api.nvim_set_hl(0, "Cursor", { bg = "#fabd2f", fg = "#282828" })
    end
  end,
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "YankHighlight",  -- Custom highlight group
      timeout = 500,              -- Duration in milliseconds (500ms = 0.5 seconds)
      on_macro = true,            -- Highlight during macro playback
      on_visual = true,           -- Highlight in visual mode
    })
  end,
})

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#504945", fg = "NONE" })

--- Center my cursor after moving horizontally 
vim.keymap.set('n', 'j', 'jzz', { silent = true, noremap = true })
vim.keymap.set('n', 'k', 'kzz', { silent = true, noremap = true })


-- Making the clipboard working in docker container from a shell
-- OSC 52 clipboard (copy ONLY, no paste waiting!)
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('+'),
  },
  paste = {
    ['+'] = function() 
      return vim.split(vim.fn.getreg('"'), '\n')  -- Return as table of lines
    end,
    ['*'] = function() 
      return vim.split(vim.fn.getreg('"'), '\n')
    end,
  },
}

-- Explicit copy to system clipboard (OSC 52)
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard (OSC 52)' })
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard (OSC 52)' })

-- Paste - use regular paste (right-click works for system clipboard)
vim.keymap.set({'n', 'v'}, '<leader>p', 'p', { desc = 'Paste' })
vim.keymap.set({'n', 'v'}, '<leader>P', 'P', { desc = 'Paste before' })

-- no creating swap files
vim.opt.swapfile = false

-- Map Enter in command mode to go to line and center
vim.api.nvim_set_keymap('n', '<CR>', 'zz<CR>', { noremap = true, silent = true })

-- Allow lazygit to handle Ctrl+j and Ctrl+k
vim.keymap.set('t', '<C-j>', '<C-j>', { noremap = true })
vim.keymap.set('t', '<C-k>', '<C-k>', { noremap = true })


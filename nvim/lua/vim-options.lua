-- basic editor settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "

-- Visual Block mode in Normal mode
-- Only works if terminal lets Neovim receive Ctrl-v
vim.keymap.set('n', '<C-v>', '<C-v>', { noremap = true })

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

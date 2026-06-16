return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },
    config = function()
        vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>')
        vim.keymap.set('n', '<leader>tF', ':TestFile<CR>')
        vim.keymap.set('n', '<leader>tS', ':TestSuite<CR>')
        vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')
        vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>')

        vim.g['test#strategy'] = 'vimux'
    end
}

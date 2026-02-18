return {
    "David-Kunz/gen.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        model = "codellama:7b-instruct", -- Matches your installed model
        display_mode = "float",          -- Use a floating window
        show_model = true,
        width = 45,                      -- Width of the "sidebar"
        height = 30,                     -- Height of the "sidebar"
        -- This part positions the window on the right side
        window_config = { 
            relative = 'editor', 
            row = 1, 
            col = vim.o.columns - 47,    -- Dynamically push to the right edge
            style = 'minimal', 
            border = 'rounded' 
        },
    },
    config = function(_, opts)
        require('gen').setup(opts)

        -- Custom command to ask a question (replacing your ExplainWithQuestion)
        vim.keymap.set({ 'n', 'v' }, '<leader>eq', function()
            local prompt = vim.fn.input("Ask Llama: ")
            if prompt ~= "" then
                require('gen').exec({ prompt = prompt })
            end
        end, { desc = "Ollama: Ask a question" })

        -- Default Menu (to see Refactor, Explain, etc.)
        vim.keymap.set({ 'n', 'v' }, '<leader>ol', ':Gen<CR>', { desc = "Ollama Menu" })
    end
}

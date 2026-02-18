return {
    'codethenpizza/lazy-llama',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('lazy-llama').setup({
            url = "http://localhost:11434",
            model = "codellama:7b-instruct",
            stream = true,
        })
        
        -- Custom command to ask questions about selected code
        vim.api.nvim_create_user_command('ExplainWithQuestion', function()
            local utils = require('lazy-llama.utils')
            local selected_text = utils.get_visual_selection()
            local file_extension = utils.get_current_buffer_file_extension()
            
            -- Prompt user for their question
            vim.ui.input({ prompt = 'Ask about the code: ' }, function(question)
                if question and question ~= '' then
                    local custom_prompt = string.format(
                        "This code is from a file with extension %s:\n\n%s\n\nQuestion: %s",
                        file_extension,
                        selected_text,
                        question
                    )
                    require('lazy-llama').get_explanation(custom_prompt)
                end
            end)
        end, { range = true })
        
        -- Optional: Add a keymap for easier access
        vim.api.nvim_set_keymap('v', '<leader>eq', ':<C-u>ExplainWithQuestion<CR>', 
            { noremap = true, silent = true, desc = "Llama: Ask question about selection" })
    end
}

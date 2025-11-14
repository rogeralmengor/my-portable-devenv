return {
  -- Modern message and popup UI
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,    -- modern search popup
        command_palette = true,  -- fancy command-line
        long_message_to_split = true, -- long messages go to split
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true }, -- skip "file written" messages
        },
      },
    },
  },

  -- Trouble for buffer/workspace diagnostics in floating windows
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      position = "float", -- floating by default
      fold_open = "",
      fold_closed = "",
      signs = {
        error = "",
        warning = "",
        hint = "",
        info = "",
      },
      use_diagnostic_signs = true,
    },
    keys = {
      -- Buffer diagnostics (floating list)
      { "<leader>q", function()
          require("trouble").open("diagnostics", {filter = { buf = 0}})
        end,
        desc = "Buffer diagnostics (Trouble)"
      },
      -- Workspace diagnostics (floating list)
      { "<leader>Q", function()
          require("trouble").open("diagnostics")
        end,
        desc = "Workspace diagnostics (Trouble)"
      },
    },
  },

  -- Individual line diagnostics (floating popup at cursor)
  {
    "nvim-lua/plenary.nvim", -- dependency for LSP stuff
    config = function()
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          scope = "line",         -- show only current line
          border = "rounded",     -- rounded popup
          source = "always",      -- show LSP name
          prefix = "●",           -- custom bullet icon
        })
      end, { desc = "Line diagnostics (floating)" })
    end,
  },
}


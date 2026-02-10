return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- 1. HARD OVERRIDE: Define the adapter manually to kill the broken path
      dap.adapters.python = {
        type = 'executable',
        command = '/opt/venv/bin/python3',
        args = { '-m', 'debugpy.adapter' },
      }

      -- 2. RESET and REBUILD configurations
      -- This clears out the ghost '/usr/src/.venv/bin/python' path
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return '/opt/venv/bin/python3'
          end,
        },
      }

      -- Gutter signs
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      -- UI Automation
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
      vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
    end,
  },
}

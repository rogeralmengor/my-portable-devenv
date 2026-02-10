return {
  -- 1. MASON: Only for managing the debugger engine
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      
      -- Auto-install debugpy if it's missing
      local mr = require("mason-registry")
      local p = mr.get_package("debugpy")
      if not p:is_installed() then
        p:install()
      end
    end,
  },

  -- 2. THE DEBUGGER: Locked to your container's environment
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

      dapui.setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- We force the path to /opt/venv/bin/python3 because 'uv' 
      -- sometimes creates a ghost .venv that breaks auto-detection.
      local python_path = "/opt/venv/bin/python3"

      -- Configure the python adapter manually
      dap.adapters.python = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      -- Configure how the debugger launches your files
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return python_path
          end,
        },
      }

      -- Automatically open/close the Debug UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Gutter signs (Icons)
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      -- Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<leader>di", dap.step_into, opts)
      vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
      vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
    end,
  },
}

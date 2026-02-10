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

      -- 1. Setup UI and Virtual Text
      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- 2. HARD OVERRIDE: Adapter Definition
      -- We manually define the adapter to force the use of the container's system python.
      -- This bypasses any automatic detection that might be picking up broken paths.
      dap.adapters.python = {
        type = 'executable',
        command = '/opt/venv/bin/python3',
        args = { '-m', 'debugpy.adapter' },
      }

      -- 3. HARD OVERRIDE: Launch Configuration
      -- We manually define how python files are launched.
      -- The 'pythonPath' function ensures the script runs using the correct interpreter.
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file (Container)",
          program = "${file}",
          pythonPath = function()
            return '/opt/venv/bin/python3'
          end,
        },
      }

      -- 4. Aesthetic: Gutter Signs (Breakpoints, etc.)
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      -- 5. Automation: Open/Close UI automatically
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- 6. Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<leader>di", dap.step_into, opts)
      vim.keymap.set("n", "<leader>dO", dap.step_out, opts)
      vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
      vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
    end,
  },
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      -- Neotest for running/debugging specific tests
      "nvim-neotest/neotest",
      "nvim-neotest/neotest-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")
      local neotest = require("neotest")

      -- 1. Mason Setup (Ensures debugpy is present)
      require("mason").setup()
      local mr = require("mason-registry")
      if not mr.is_installed("debugpy") then
        vim.cmd("MasonInstall debugpy")
      end

      -- 2. Basic Plugin Setup
      dapui.setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- 3. THE PATH: Fixed to your container/UV environment
      local python_path = "/opt/venv/bin/python3"

      -- 4. HARD OVERRIDE: Adapter & Configuration
      -- This stops the debugger from guessing wrong and crashing
      dap.adapters.python = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch Script (Standard)",
          program = "${file}",
          pythonPath = function() return python_path end,
        },
        {
          type = 'python',
          request = 'launch',
          name = "Debug Test (Pytest)",
          module = "pytest",
          args = { "${file}", "-sv" },
          pythonPath = function() return python_path end,
        },
      }

      -- 5. NEOTEST Setup (The "Failing Test" Fix)
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { adapter = "python" },
            runner = "pytest",
            python = python_path,
          }),
        },
      })

      -- 6. UI Automation
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- 7. COOL SYMBOLS
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      -- 8. KEYMAPS
      local opts = { noremap = true, silent = true }
      
      -- Standard Debugging
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
      vim.keymap.set("n", "<leader>du", dapui.toggle, opts)

      -- Test-Specific Debugging
      -- Use this when cursor is inside a test function
      vim.keymap.set("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug Nearest Test" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle Test Summary" })
    end,
  },
}

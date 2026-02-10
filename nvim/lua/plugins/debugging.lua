return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "nvim-neotest/neotest",
      "nvim-neotest/neotest-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local neotest = require("neotest")

      require("mason").setup()
      dapui.setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      local python_path = "/opt/venv/bin/python3"

      -- 1. ADAPTER
      dap.adapters.python = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      -- 2. CONFIGURATIONS
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Debug Test (Pytest)",
          module = "pytest",
          args = { "${file}", "-sv", "--noconftest" }, -- -sv is crucial for seeing output
          console = "integratedTerminal",
          pythonPath = function() return python_path end,
          justMyCode = false, -- Set to true if you want to skip library code
        },
      }

      -- 3. NEOTEST
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { adapter = "python" },
            runner = "pytest",
            python = python_path,
          }),
        },
      })

      -- 4. UI AUTOMATION (Fixed to keep window open)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- We REMOVE/COMMENT the auto-close on terminate 
      -- so the UI stays open for you to read the error.
      -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- 5. SYMBOLS
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      -- 6. KEYMAPS
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>dq", function() 
        dap.terminate()
        dapui.close() -- Manually close when you are DONE
      end, opts)
      vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, opts)
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, opts)
      -- Stepping
      vim.keymap.set("n", "<leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<leader>di", dap.step_into, opts)
    end,
  },
}

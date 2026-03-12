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
      local dap_python = require("dap-python")
      local neotest = require("neotest")

      require("mason").setup()
      dapui.setup({})
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- Always show signcolumn so breakpoint icons don't shift text
      vim.opt.signcolumn = "yes"

      -- 1. ADAPTER: use system python3 (has debugpy installed globally via Dockerfile)
      dap_python.setup("/usr/local/bin/python3")
      dap_python.test_runner = "pytest"

      -- 2. PYTHON RESOLUTION: at debug-time, use the active venv if sourced
      dap_python.resolve_python = function()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and vim.fn.executable(venv .. "/bin/python3") == 1 then
          vim.notify("DAP: using venv → " .. venv, vim.log.levels.INFO)
          return venv .. "/bin/python3"
        end
        vim.notify("DAP: no venv active, using system python3", vim.log.levels.WARN)
        return "/usr/local/bin/python3"
      end

      -- 3. CONFIGURATIONS: add pytest launch config on top of dap-python defaults
      table.insert(dap.configurations.python, {
      type = "python",
      request = "launch",
      name = "Debug Current File",
      program = "${file}",          -- runs whatever file is open in nvim
      console = "integratedTerminal",
      justMyCode = false,
      cwd = "${workspaceFolder}",   -- CRUCIAL: sets CWD to your project root
                                -- so config files are found correctly
      })

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Debug Test (Pytest)",
        module = "pytest",
        args = { "${file}", "-sv", "--no-header" },
        console = "integratedTerminal",
        justMyCode = false,
        cwd = "${workspaceFolder}",
      })

      -- 4. NEOTEST
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { adapter = "python" },
            runner = "pytest",
            python = function()
              local venv = os.getenv("VIRTUAL_ENV")
              if venv and vim.fn.executable(venv .. "/bin/python3") == 1 then
                return venv .. "/bin/python3"
              end
              return "/usr/local/bin/python3"
            end,
          }),
        },
      })

      -- 5. UI AUTOMATION (kept open after session so you can read output)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- Uncomment these if you want the UI to auto-close on session end:
      -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- 6. SYMBOLS (defined AFTER dap_python.setup so they are not overwritten)
      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DiagnosticSignError",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "◆",
        texthl = "DiagnosticSignWarn",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "○",
        texthl = "DiagnosticSignError",
      })
      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "◉",
        texthl = "DiagnosticSignInfo",
      })

      -- 7. KEYMAPS
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>dq", function()
        dap.terminate()
        dapui.close()
      end, opts)
      vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, opts)
      vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, opts)
      vim.keymap.set("n", "<leader>dn", dap_python.test_method, opts)
      vim.keymap.set("n", "<leader>df", dap_python.test_class, opts)
      -- Stepping
      vim.keymap.set("n", "<leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<leader>di", dap.step_into, opts)
    end,
  },
}

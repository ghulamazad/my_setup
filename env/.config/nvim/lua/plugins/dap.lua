-- lua/plugins/dap.lua
--
-- nvim-dap is the Neovim client for the Debug Adapter Protocol — the
-- same underlying protocol VS Code's debuggers use. This file sets up
-- the CORE debugging experience (breakpoints, stepping, UI, inline
-- variable values) with no language-specific logic. Go's specifics
-- live in dap-go.lua; Java's will live in a dap-java.lua later,
-- attaching to this same core.

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" }, -- required by dap-ui
    },
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
    {
      "<leader>DB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: conditional breakpoint",
    },
    { "<leader>Dc", function() require("dap").continue() end, desc = "Debug: continue / start" },
    { "<leader>Di", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<leader>Do", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<leader>DO", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>Dt", function() require("dap").terminate() end, desc = "Debug: terminate session" },
    { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
    { "<leader>Du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
    { "<leader>Dl", function() require("dap").run_last() end, desc = "Debug: re-run last" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup({})

    -- Auto-open the debugger UI the moment a session actually starts
    -- (not when you merely set a breakpoint), and auto-close it when
    -- the session ends — matches the "appears when needed, gets out
    -- of the way otherwise" feel of JetBrains' debugger.
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Breakpoint gutter signs — filled circle for a set breakpoint,
    -- an arrow for wherever execution is currently paused.
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })
  end,
}
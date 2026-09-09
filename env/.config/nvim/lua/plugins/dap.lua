return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" }, -- required by dap-ui for async UI updates
    },
    "theHamsta/nvim-dap-virtual-text", -- shows variable values inline next to code while stepping, not just in a side panel
    "jay-babu/mason-nvim-dap.nvim",    -- bridges Mason-installed debug adapters into nvim-dap, same role mason-lspconfig plays for LSP
    "mfussenegger/nvim-dap-python", 
},
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue / Start debugging" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run last debug config" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate debug session" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover: inspect variable" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      ensure_installed = { "delve", "java-debug-adapter", "java-test", "debugpy", "codelldb" },
      automatic_installation = true,
      handlers = {}, -- empty = use each adapter's default handler; we configure adapters ourselves per-language below for full control
    })

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },   -- local variables in current stack frame
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },   -- call stack
            { id = "watches", size = 0.2 },  -- expressions you're explicitly watching
          },
          position = "left",
          size = 40,
        },
        {
          elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
          position = "bottom",
          size = 10,
        },
      },
    })

    require("nvim-dap-virtual-text").setup({
      commented = true, -- shows values as a comment-style annotation at end of line, consistent visually with how diagnostics/blame already render
    })

    -- Auto-open/close the UI exactly when a debug session starts/ends —
    -- you shouldn't have to remember to toggle it manually every time
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- Breakpoint sign styling — matches the diagnostic sign convention from Stage 2
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

    -- Per-language adapter/configuration setup — deferred to here
    -- (inside nvim-dap's own config function) rather than required
    -- from init.lua directly, because these files call require("dap")
    -- at load time, and nvim-dap isn't guaranteed to be installed yet
    -- if required before lazy.nvim finishes bootstrapping.
    require("dap.go")
    require("dap.python")
    require("dap.rust")
  end,
}
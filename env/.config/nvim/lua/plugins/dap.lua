-- lua/plugins/dap.lua
-- nvim-dap + dap-ui + virtual text. Per-language adapters live in lua/dap/*.lua
-- and are loaded inside the config() below after dap itself is ready.
--
-- Keymaps use <leader>d prefix (think: Debug).
-- All DAP UI windows appear in a pre-configured split layout.

return {
    -- ── Core DAP ──────────────────────────────────────────────────────────────
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI: provides sidebar with scopes, watches, stacks, breakpoints
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
            },
            -- Virtual text: shows variable values inline while stepping
            { "theHamsta/nvim-dap-virtual-text" },
            -- Language-specific helpers
            { "mfussenegger/nvim-dap-python" }, -- python
        },

        keys = {
            -- ── Run & Control ─────────────────────────────────────────────────
            { "<leader>dc", function() require("dap").continue()          end, desc = "DAP: Continue / Start" },
            { "<leader>dq", function() require("dap").terminate()         end, desc = "DAP: Terminate session" },
            { "<leader>dr", function() require("dap").restart()           end, desc = "DAP: Restart session" },

            -- ── Step ──────────────────────────────────────────────────────────
            { "<leader>do", function() require("dap").step_over()         end, desc = "DAP: Step over" },
            { "<leader>di", function() require("dap").step_into()         end, desc = "DAP: Step into" },
            { "<leader>dO", function() require("dap").step_out()          end, desc = "DAP: Step out" },

            -- ── Breakpoints ───────────────────────────────────────────────────
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
            { "<leader>dB", function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, desc = "DAP: Conditional breakpoint" },
            { "<leader>dl", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point msg: "))
            end, desc = "DAP: Log point" },

            -- ── UI ────────────────────────────────────────────────────────────
            { "<leader>du", function() require("dapui").toggle()          end, desc = "DAP: Toggle UI" },
            { "<leader>de", function() require("dapui").eval()            end, desc = "DAP: Eval expression", mode = { "n", "v" } },

            -- ── REPL ──────────────────────────────────────────────────────────
            { "<leader>dR", function() require("dap").repl.open()         end, desc = "DAP: Open REPL" },
        },

        config = function()
            local dap    = require("dap")
            local dapui  = require("dapui")

            -- ── dap-virtual-text ───────────────────────────────────────────────
            require("nvim-dap-virtual-text").setup({
                commented = true,   -- show virtual text as comment
            })

            -- ── dap-ui layout ─────────────────────────────────────────────────
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                layouts = {
                    {
                        -- Left sidebar: scopes + watches
                        elements = {
                            { id = "scopes",      size = 0.40 },
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks",      size = 0.20 },
                            { id = "watches",     size = 0.20 },
                        },
                        size     = 40,
                        position = "left",
                    },
                    {
                        -- Bottom panel: REPL + console
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size     = 12,
                        position = "bottom",
                    },
                },
                floating = { border = "rounded" },
            })

            -- ── Auto-open / auto-close dapui ──────────────────────────────────
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- ── Signs ─────────────────────────────────────────────────────────
            vim.fn.sign_define("DapBreakpoint",          { text = "🔴", texthl = "DapBreakpoint" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition" })
            vim.fn.sign_define("DapLogPoint",            { text = "🔵", texthl = "DapLogPoint" })
            vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped", linehl = "DapStopped" })

            -- ── Per-language adapters ─────────────────────────────────────────
            -- Each file in lua/dap/*.lua configures its adapter+launch config.
            -- They must be loaded after dap itself is initialised.
            require("dap.go")
            require("dap.python")
            require("dap.rust")
        end,
    },
}

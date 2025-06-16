return {
    'mfussenegger/nvim-dap',
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui', -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio', -- optional
        -- 'mason-org/mason.nvim',
        -- 'jay-babu/mason-nvim-dap.nvim',
        -- Language-specific debuggers
        'leoluz/nvim-dap-go', -- Golang
        -- Shows variable values inline as virtual text
        'theHamsta/nvim-dap-virtual-text'
    },
    keys = {
        {
            '<F5>',
            function() require('dap').continue() end,
            desc = 'Debug: Start/Continue'
        },
        {
            '<F1>',
            function() require('dap').step_into() end,
            desc = 'Debug: Step Into'
        },
        {
            '<F2>',
            function() require('dap').step_over() end,
            desc = 'Debug: Step Over'
        },
        {
            '<F3>',
            function() require('dap').step_out() end,
            desc = 'Debug: Step Out'
        }, {
            '<leader>b',
            function() require('dap').toggle_breakpoint() end,
            desc = 'Debug: Toggle Breakpoint'
        }, {
            '<leader>B',
            function()
                require('dap').set_breakpoint(vim.fn
                                                  .input 'Breakpoint condition: ')
            end,
            desc = 'Debug: Set Breakpoint'
        },
        {
            '<F7>',
            function() require('dapui').toggle() end,
            desc = 'Debug: See last session result.'
        }
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        -- optional
        -- require('mason-nvim-dap').setup {
        --     automatic_installation = true,
        --     handlers = {},
        --     ensure_installed = {
        --         'delve',
        --     },
        -- }

        -- Dap UI setup
        dapui.setup {
            icons = {expanded = '▾', collapsed = '▸', current_frame = '*'},
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏'
                }
            }
        }

        -- Automatically open/close DAP UI
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Setup virtual text to show variable values inline
        require("nvim-dap-virtual-text").setup()

        require('dap-go').setup({
            delve = {
                -- Path to delve executable, only needed if you're not using mason-nvim-dap
                path = vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or
                    "~/.local/go/bin/dlv"
            }
        })
    end
}

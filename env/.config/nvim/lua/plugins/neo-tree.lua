-- lua/plugins/neo-tree.lua
-- neo-tree.nvim: file explorer tree replacing netrw.
-- Opened automatically when nvim is called with a directory (see core/netrw-replacement.lua).
-- <leader>e toggles the sidebar; <leader>E reveals the current file in the tree.

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch       = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd  = "Neotree",
        keys = {
            {
                "<leader>e",
                "<cmd>Neotree toggle<CR>",
                desc = "Toggle file explorer",
            },
            {
                "<leader>E",
                "<cmd>Neotree reveal<CR>",
                desc = "Reveal file in explorer",
            },
            {
                "<leader>ge",
                "<cmd>Neotree git_status<CR>",
                desc = "Git status in neo-tree",
            },
        },
        opts = {
            close_if_last_window = true,  -- close nvim when neo-tree is the only window

            default_component_configs = {
                indent = {
                    indent_size        = 2,
                    with_markers       = true,
                    indent_marker      = "│",
                    last_indent_marker = "└",
                    expander_collapsed = "",
                    expander_expanded  = "",
                },
                icon = {
                    folder_closed = "",
                    folder_open   = "",
                    folder_empty  = "󰜌",
                },
                git_status = {
                    symbols = {
                        added     = "✚",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "󰁕",
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    },
                },
                modified = { symbol = "●" },
            },

            window = {
                position = "left",
                width     = 35,
                mappings  = {
                    ["<space>"] = "none",   -- don't let neo-tree shadow our mapleader
                    ["<C-s>"]   = "open_split",
                    ["<C-v>"]   = "open_vsplit",
                    ["Y"]       = {
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path)
                            vim.notify("Copied path: " .. path, vim.log.levels.INFO)
                        end,
                        desc = "Copy absolute path",
                    },
                },
            },

            filesystem = {
                bind_to_cwd      = false,
                follow_current_file = { enabled = true },  -- keep tree in sync while editing
                use_libuv_file_watcher = true,             -- reflect external file changes
                filtered_items = {
                    hide_dotfiles   = false,
                    hide_gitignored = true,
                    hide_hidden     = true,
                    never_show = { ".DS_Store", "thumbs.db" },
                },
            },

            buffers = {
                follow_current_file = { enabled = true },
            },
        },
    },
}

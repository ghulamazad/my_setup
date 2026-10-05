-- lua/plugins/telescope.lua
-- telescope.nvim: fuzzy finder for files, grep, LSP symbols, git objects.
-- ripgrep (pacman: ripgrep) must be available for live_grep.
-- fd (pacman: fd) is used as the file finder for speed.
--
-- Keymaps use <leader>s prefix (Search).

return {
    {
        "nvim-telescope/telescope.nvim",
        branch       = "0.1.x",
        event        = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Native fzf sorter: order-of-magnitude faster matching
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            -- UI selector: use telescope for vim.ui.select (code actions, etc.)
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons" },
        },
        keys = {
            -- Files
            { "<leader>sf", "<cmd>Telescope find_files<CR>",                desc = "Find files" },
            { "<leader>sr", "<cmd>Telescope oldfiles<CR>",                  desc = "Recent files" },
            { "<leader>sb", "<cmd>Telescope buffers sort_mru=true<CR>",     desc = "Buffers" },

            -- Grep
            { "<leader>sg", "<cmd>Telescope live_grep<CR>",                 desc = "Live grep" },
            { "<leader>sw", "<cmd>Telescope grep_string<CR>",               desc = "Grep word under cursor", mode = { "n", "v" } },

            -- LSP
            { "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>",      desc = "Document symbols" },
            { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<CR>",     desc = "Workspace symbols" },
            { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<CR>",       desc = "Buffer diagnostics" },
            { "<leader>sD", "<cmd>Telescope diagnostics<CR>",               desc = "All diagnostics" },

            -- Git
            { "<leader>sgf", "<cmd>Telescope git_files<CR>",               desc = "Git files" },
            { "<leader>sgl", "<cmd>Telescope git_commits<CR>",             desc = "Git commits" },
            { "<leader>sgb", "<cmd>Telescope git_branches<CR>",            desc = "Git branches" },

            -- Neovim meta
            { "<leader>sh", "<cmd>Telescope help_tags<CR>",                desc = "Help tags" },
            { "<leader>sk", "<cmd>Telescope keymaps<CR>",                  desc = "Keymaps" },
            { "<leader>sc", "<cmd>Telescope commands<CR>",                 desc = "Commands" },
            { "<leader>s.", "<cmd>Telescope resume<CR>",                   desc = "Resume last search" },
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix   = "  ",
                    selection_caret = " ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55 },
                        vertical   = { mirror = false },
                    },
                    file_ignore_patterns = {
                        "%.git/",
                        "node_modules/",
                        "vendor/",
                        "%.lock",
                        "__pycache__/",
                        "target/",       -- Rust build dir
                    },
                    mappings = {
                        i = {
                            ["<C-j>"]   = actions.move_selection_next,
                            ["<C-k>"]   = actions.move_selection_previous,
                            ["<C-q>"]   = actions.send_to_qflist + actions.open_qflist,
                            ["<Esc>"]   = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        -- fd respects .gitignore; hidden=true still shows dot-files
                        find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy                   = true,
                        override_generic_sorter  = true,
                        override_file_sorter     = true,
                        case_mode               = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
}
